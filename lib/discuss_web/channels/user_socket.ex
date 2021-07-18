defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  channel "comments:*", DiscussWeb.CommentsChannel

  #get "/comments/:id" , CommentController  , :join , :handle_in
  #transport :websocket , Phoenix.Transports.WebSocket

  @impl true
  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket,"key" , token) do
      {:ok , user_id} ->
        # IO.puts("++++++++++++++++++++++")
        {:ok , assign(socket, :user_id , user_id)}
        # {:ok , user_id}
      {:error , _error} ->
        :error

    end
  end


  @impl true
  def id(_socket), do: nil
end
