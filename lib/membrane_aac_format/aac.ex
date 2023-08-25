defmodule Membrane.AAC do
  @moduledoc """
  Capabilities for [Advanced Audio Codec](https://wiki.multimedia.cx/index.php/Understanding_AAC).
  """

  @type profile :: :main | :LC | :SSR | :LTP | :HE | :HEv2 | nil
  @type samples_per_frame :: 1024 | 960
  @type mpeg_version :: 2 | 4

  @typedoc """
  MPEG version identifiers.

  `0` indicates MPEG-4 and `1` indicates MPEG-2
  """
  @type mpeg_version_id :: 0 | 1

  @typedoc """
  Indicates whether stream contains AAC frames only or are they encapsulated
  in [ADTS](https://wiki.multimedia.cx/index.php/ADTS)
  """
  @type encapsulation :: :none | :ADTS

  @typedoc """
  Identifiers of [MPEG Audio Object Types](https://wiki.multimedia.cx/index.php/MPEG-4_Audio#Audio_Object_Types)
  """
  @type audio_object_type_id :: 1..5 | 29

  @typedoc """
  Identifiers of [MPEG Audio sampling frequencies](https://wiki.multimedia.cx/index.php/MPEG-4_Audio#Sampling_Frequencies)
  """
  @type sampling_frequency_id :: 0..12 | 15

  @typedoc """
  Identifiers of [MPEG Audio channel configurations](https://wiki.multimedia.cx/index.php/MPEG-4_Audio#Channel_Configurations)
  """
  @type channel_config_id :: 0..7

  @typedoc """
  AAC frame length identifiers.

  `0` indicates 1024 samples/frame and `1` - 960 samples/frame.
  """
  @type frame_length_id :: 0 | 1

  @typedoc """
  Contains the configuration data of the audio stream. The options are:
  * Elementary Stream Descriptor, `:esds` - ISO/IEC 14496-14
  * Audio Specific Config, `:audio_specific_config` - ISO/IEC 14496-3
  If the data is already parsed and the stream doesn't contain external config it can be set to nil.
  """
  @type config :: {:esds | :audio_specific_config, binary()} | nil

  @type t :: %__MODULE__{
          profile: profile(),
          mpeg_version: mpeg_version(),
          sample_rate: pos_integer() | nil,
          channels: pos_integer() | nil,
          samples_per_frame: samples_per_frame(),
          frames_per_buffer: pos_integer(),
          encapsulation: encapsulation(),
          config: config()
        }

  defstruct sample_rate: nil,
            channels: nil,
            profile: nil,
            mpeg_version: 2,
            samples_per_frame: 1024,
            frames_per_buffer: 1,
            encapsulation: :none,
            config: nil

  defp audio_object_type_map(),
    do:
      BiMap.new(%{
        1 => :main,
        2 => :LC,
        3 => :SSR,
        4 => :LTP,
        5 => :HE,
        29 => :HEv2
      })

  defp sampling_frequency_map(),
    do:
      BiMap.new(%{
        0 => 96_000,
        1 => 88_200,
        2 => 64_000,
        3 => 48_000,
        4 => 44_100,
        5 => 32_000,
        6 => 24_000,
        7 => 22_050,
        8 => 16_000,
        9 => 12_000,
        10 => 11_025,
        11 => 8000,
        12 => 7350,
        15 => :explicit
      })

  defp channel_config_map(),
    do:
      BiMap.new(%{
        0 => :AOT_specific,
        1 => 1,
        2 => 2,
        3 => 3,
        4 => 4,
        5 => 5,
        6 => 6,
        7 => 8
      })

  defp frame_length_map(),
    do:
      BiMap.new(%{
        0 => 1024,
        1 => 960
      })

  defp mpeg_version_map(),
    do:
      BiMap.new(%{
        0 => 4,
        1 => 2
      })

  @spec aot_id_to_profile(audio_object_type_id()) :: profile()
  def aot_id_to_profile(audio_object_type_id),
    do: BiMap.fetch!(audio_object_type_map(), audio_object_type_id)

  @spec profile_to_aot_id(profile()) :: audio_object_type_id()
  def profile_to_aot_id(profile), do: BiMap.fetch_key!(audio_object_type_map(), profile)

  @spec sampling_frequency_id_to_sample_rate(sampling_frequency_id()) :: pos_integer() | :explicit
  def sampling_frequency_id_to_sample_rate(sampling_frequency_id),
    do: BiMap.fetch!(sampling_frequency_map(), sampling_frequency_id)

  @spec sample_rate_to_sampling_frequency_id(sample_rate :: pos_integer()) ::
          sampling_frequency_id()
  def sample_rate_to_sampling_frequency_id(sample_rate),
    do: BiMap.get_key(sampling_frequency_map(), sample_rate, 15)

  @spec channel_config_id_to_channels(channel_config_id()) :: pos_integer() | :AOT_specific
  def channel_config_id_to_channels(channel_config_id),
    do: BiMap.fetch!(channel_config_map(), channel_config_id)

  @spec channels_to_channel_config_id(channels :: pos_integer() | :AOT_specific) ::
          channel_config_id()
  def channels_to_channel_config_id(channels),
    do: BiMap.fetch_key!(channel_config_map(), channels)

  @spec frame_length_id_to_samples_per_frame(frame_length_id()) :: samples_per_frame()
  def frame_length_id_to_samples_per_frame(frame_length_id),
    do: BiMap.fetch!(frame_length_map(), frame_length_id)

  @spec samples_per_frame_to_frame_length_id(samples_per_frame()) :: pos_integer()
  def samples_per_frame_to_frame_length_id(samples_per_frame),
    do: BiMap.fetch_key!(frame_length_map(), samples_per_frame)

  @spec mpeg_version_to_mpeg_version_id(mpeg_version()) :: mpeg_version_id()
  def mpeg_version_to_mpeg_version_id(mpeg_version),
    do: BiMap.fetch_key!(mpeg_version_map(), mpeg_version)

  @spec mpeg_version_id_to_mpeg_version(mpeg_version_id()) :: mpeg_version()
  def mpeg_version_id_to_mpeg_version(mpeg_version_id),
    do: BiMap.fetch!(mpeg_version_map(), mpeg_version_id)
end
