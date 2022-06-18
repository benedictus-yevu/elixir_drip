# defmodule Example.Worker do
#   @callback init(state :: term) :: {:ok , new_state :: term} | {:error, reason ::term}
#
#   @callback perform(args :: term, state :: term) ::
#       {:ok, result :: term, new_state :: term}
#       | {:error,reason :: term, new_state :: term}
# end
#
# defmodule Example.Downloader do
#   @behaviour Example.Worker
#
#   def init(opts), do; {:ok, opts}
#
#   def perform(url,opts) do
#     url
#     |> HTTPoison.get!()
#     |> Map.fetch(:body)
#     |> write_file(opts[:path])
#     |> respond(opts)
#   end
# end
