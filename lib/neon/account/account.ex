defmodule Neon.Account do
  @moduledoc """
  The Accounts context.
  """

  use Neon, :context

  alias Neon.Account.{Session, User}

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
  Grabs a user by their email address.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_by_email!("testing@example.com")
      %User{}

      iex> get_user_by_email!("nope@example.com")
      ** (Ecto.NoResultsError)

  """
  def get_user_by_email!(email), do: Repo.get_by!(User, email: email)

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
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, user}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
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
    |> Query.preload([:user])
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
    check =
      params.email
      |> get_user_by_email!()
      |> Argon2.check_pass(params.password)

    case check do
      {:ok, %User{} = user} ->
        create_session(Map.put(params, :user_id, user.id))

      {:error, "invalid password"} ->
        {:error, :invalid_password}

      _ ->
        {:error, :not_found}
    end
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
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
