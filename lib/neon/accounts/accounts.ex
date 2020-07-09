defmodule Neon.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query

  alias Neon.Repo
  alias Neon.Accounts.{Session, User}

  def data() do
    Dataloader.Ecto.new(Neon.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Gets a single session.

  Raises `Ecto.NoResultsError` if the Session does not exist.

  ## Examples

      iex> get_session!(123)
      %User{}

      iex> get_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_session!(id) do
    Session
    |> preload([:user])
    |> Repo.get!(id)
  end

  @doc """
  Creates a session.

  ## Examples

      iex> create_session(%{field: value})
      {:ok, %Session{}}

      iex> create_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session(attrs \\ %{}) do
    changeset = Session.changeset(%Session{}, attrs)

    with {:ok, session} <- Repo.insert(changeset),
         preloaded_session <- Repo.preload(session, :user) do
      {:ok, preloaded_session}
    else
      res -> res
    end
  end

  @doc """
  Checks if the given session is valid for use or not

  ## Examples

      iex> valid_session?(valid_session)
      true

  """
  def valid_session?(session) do
    DateTime.compare(DateTime.utc_now(), session.expired_at) == :lt
  end

  @doc """
  Logins in a user with the given params

  ## Examples

      iex> login_user(%{
        email: "admin@example.com",
        password: "password",
        ip: "127.0.0.1",
        user_agent: "agent"
      })
      {:ok, %Session{}}

      iex> login_user(%{})
      {:error, :not_found}

  """
  def login_user(params) do
    user = Repo.get_by(User, email: params.email)

    case Argon2.check_pass(user, params.password) do
      {:ok, %User{}} ->
        create_session(Map.put(params, :user_id, user.id))

      {:error, "invalid password"} ->
        {:error, :invalid_password}

      _ ->
        {:error, :not_found}
    end
  end

  def login_user(_params) do
    Argon2.no_user_verify()
    {:error, :not_found}
  end

  @doc """
  Registers a new user and creates a session for them.

  ## Examples

      iex> register_user(%{
        name: "Admin Example",
        email: "admin@example.com",
        password: "password",
        ip: "127.0.0.1",
        user_agent: "agent"
      })
      {:ok, %Session{}}

      iex> register_user(%{})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(params) do
    case create_user(params) do
      {:ok, user} ->
        create_session(Map.put(params, :user_id, user.id))

      res ->
        res
    end
  end
end
