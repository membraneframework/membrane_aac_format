defmodule Membrane.RemoteStream.AAC do
  @moduledoc """
  Format definition for Remote AAC Stream with known audio decoder configuration
  """

  @enforce_keys [:audio_specific_config]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          audio_specific_config: binary()
        }
end
