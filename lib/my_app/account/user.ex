defmodule MyApp.Account.User do
  # Schemas are basically models like in Laravel
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
 
  schema "users" do
    field :is_active, :boolean, default: false
    field :email, :string

    field :password, :string, virtual: true
    field :password_hash, :string

    # Add support for microseconds at the app level
    # for this specific schema
    # timestamps(type: :utc_datetime_usec)
    timestamps(type: :utc_datetime_usec)
  end

  # This is where we validate data before writing to the database
  @doc false
  def changeset(user, attrs) do
    # The "|>" symbol means that "piping" is taking place. That means the return of the first function, it becomes the first argument of the next function in the "pipeline".
    user
    |> cast(attrs, [:email, :is_active, :password])
    |> validate_required([:email, :is_active, :password])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
