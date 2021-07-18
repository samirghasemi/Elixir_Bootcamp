defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb , :channel
  alias Discuss.Repo
  alias Discuss.Topic
  alias Discuss.Comment


  def join("comments:"<>topic_id , _params , socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
    |> Repo.get(topic_id)
    |> Repo.preload(comments: [:user])
    {:ok , %{comments: topic.comments} ,assign(socket, :topic , topic)}

  end

  def handle_in(_name , %{"content" => content} = _message , socket) do
    topic = socket.assigns.topic
    userID = socket.assigns.user_id
    changeset = topic
    |> Ecto.build_assoc(:comments , user_id: userID)
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok , comment} ->
        broadcast!(socket,"comments:#{topic.id}:new" , %{comment: comment})
        {:reply , :ok , socket}
      {:error , _reason} ->
        {:reply, {:error , %{errors: changeset}}, socket}
    end
  end
end
