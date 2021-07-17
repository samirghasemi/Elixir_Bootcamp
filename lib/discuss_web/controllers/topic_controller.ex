defmodule DiscussWeb.TopicController do
  use DiscussWeb , :controller
  alias Discuss.Topic
  alias Discuss.Repo
  import Routes

  plug DiscussWeb.Plugs.RequireAuth when action in [:new , :create , :edit, :update , :delete]

  def index(conn , _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn , _params) do
    changeset = Topic.changeset(%Topic{} , %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn , %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{} , topic)
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
