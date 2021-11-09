defmodule Membrane.RemoteStream.AAC do
  @moduledoc """
  Capabilities defining Remote AAC Stream with known audio decoder configuration
  """
  alias Membrane.AAC

  @enforce_keys [:audio_specific_config]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          audio_specific_config: binary()
        }

  @spec to_aac_t(__MODULE__.t()) :: AAC.t()
  def to_aac_t(%__MODULE__{
        audio_specific_config:
          <<profile::5, sr_index::4, channel_configuration::4, frame_length_flag::1, _rest::bits>>
      }),
      do: %AAC{
        profile: AAC.aot_id_to_profile(profile),
        mpeg_version: 4,
        sample_rate: AAC.sampling_frequency_id_to_sample_rate(sr_index),
        channels: AAC.channel_config_id_to_channels(channel_configuration),
        encapsulation: :none,
        samples_per_frame: if(frame_length_flag == 1, do: 1024, else: 960)
      }
end
