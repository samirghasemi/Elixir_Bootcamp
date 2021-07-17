defmodule DiscussWeb.TopicController do
  use DiscussWeb , :controller
  alias Discuss.Topic
  alias Discuss.Repo
  import Routes
  alias DiscussWeb.Router.Helpers


  plug DiscussWeb.Plugs.RequireAuth when action in [:new , :create , :edit, :update , :delete]
  plug :exists? when action in [:edit , :update , :delete , :show]
  plug :check_topic_owner when action in [:update , :edit , :delete]

  def exists?(conn , _params) do
    %{params: %{"id" =>topic_id}} = conn
    topic = Repo.get(Topic , topic_id)
    if topic == nil do
      conn
      |> put_flash(:error , "this topic is not exists!")
      |> redirect(to: Helpers.topic_path(conn , :index))
      |> halt()
    else
      conn
    end
  end


  def check_topic_owner(conn , _params) do
    %{params: %{"id" =>topic_id}} = conn
    topic = Repo.get(Topic , topic_id)
    if topic.user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error , "you can not edit this!")
      |> redirect(to: Helpers.topic_path(conn , :index))
      |> halt()
    end
  end

  def show(conn , %{"id" => topic_id}) do
    topic = Repo.get!(Topic , topic_id)
    render conn ,"show.html" , topic: topic
  end
  def index(conn , _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn , _params) do
    changeset = Topic.changeset(%Topic{} , %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn , %{"topic" => topic}) do

    # changeset = Topic.changeset(%Topic{} , topic)
    user = conn.assigns.user
    changeset = user
    |> Ecto.build_assoc(:topics)
    |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok , _topic} ->
        conn
        |> put_flash(:info , "Topic created!")
        |> redirect(to: topic_path(conn,:index))
      {:error , changeset} ->
        render conn,"new.html" , changeset: changeset
    end
  end


  def edit(conn , %{"id" => topic_id}) do
    topic = Repo.get(Topic , topic_id)
    changeset = Topic.changeset(topic)
    render conn , "edit.html" , changeset: changeset , topic: topic
  end

  def update(conn , %{"id" => id , "topic" => topic } =_params) do
    old = Repo.get(Topic , id)
    changeset = Topic.changeset(old , topic)
    case Repo.update(changeset) do
      {:ok , _topic} ->
        conn
        |> put_flash(:info , "Topic Updated!")
        |> redirect(to: topic_path(conn , :index))
      {:error , changeset} ->
        render conn , "edit.html" , changeset: changeset ,topic: old
    end
  end

  def delete(conn, %{"id"=>id} = _params) do

    Repo.get!(Topic,id) |> Repo.delete!
    #Repo.delete(Topic,id)
    conn
    |> put_flash(:info ,"Topic Deleted!")
    |> redirect(to: topic_path(conn , :index))
  end
end
