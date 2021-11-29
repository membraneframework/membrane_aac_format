defmodule Membrane.AAC.RemoteStream do
  @moduledoc """
  Format definition for unparsed AAC stream with audio decoder configuration transmitted out-of-band.

  Example of such a stream is AAC depayloaded from a container like MP4 or FLV, where audio specific config
  is signalled outside of the AAC bytestream.

  `encapsulation: :none` should be assumed.
  """

  @enforce_keys [:audio_specific_config]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          audio_specific_config: binary()
        }
end
