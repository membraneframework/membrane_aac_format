defmodule Membrane.AAC do
  @moduledoc """
  Capabilities for [Advanced Audio Codec](https://wiki.multimedia.cx/index.php/Understanding_AAC).
  """

  @type profile_t :: :main | :LC | :SSR | :LTP | :HE | :HEv2
  @type mpeg_version_t :: 2 | 4
  @type samples_per_frame_t :: 1024 | 960

  @typedoc """
  Indicates whether stream contains AAC frames only or are they encapsulated
  in [ADTS](https://wiki.multimedia.cx/index.php/ADTS)
  """
  @type encapsulation_t :: :none | :ADTS

  @typedoc """
  Identifiers of [MPEG Audio Object Types](https://wiki.multimedia.cx/index.php/MPEG-4_Audio#Audio_Object_Types)
  """
  @type audio_object_type_id_t :: 1..5 | 29

  @typedoc """
  Identifiers of [MPEG Audio sampling frequencies](https://wiki.multimedia.cx/index.php/MPEG-4_Audio#Sampling_Frequencies)
  """
  @type sampling_frequency_id_t :: 0..12 | 15

  @typedoc """
  Identifiers of [MPEG Audio channel configurations](https://wiki.multimedia.cx/index.php/MPEG-4_Audio#Channel_Configurations)
  """
  @type channel_config_id_t :: 0..7

  @typedoc """
  AAC frame length identifiers.

  `0` indicates 1024 samples/frame and `1` - 960 samples/frame.
  """
  @type frame_length_id_t :: 0 | 1

  @type t :: %__MODULE__{
          profile: profile_t,
          mpeg_version: mpeg_version_t,
          sample_rate: pos_integer,
          channels: pos_integer,
          samples_per_frame: 1024 | 960,
          frames_per_buffer: pos_integer,
          encapsulation: encapsulation_t
        }

  @enforce_keys [
    :profile,
    :sample_rate,
    :channels
  ]
  defstruct @enforce_keys ++
              [
                mpeg_version: 2,
                samples_per_frame: 1024,
                frames_per_buffer: 1,
                encapsulation: :none
              ]

  @audio_object_type BiMap.new(%{
                       1 => :main,
                       2 => :LC,
                       3 => :SSR,
                       4 => :LTP,
                       5 => :HE,
                       29 => :HEv2
                     })

  @sampling_frequency BiMap.new(%{
                        0 => 96000,
                        1 => 88200,
                        2 => 64000,
                        3 => 48000,
                        4 => 44100,
                        5 => 32000,
                        6 => 24000,
                        7 => 22050,
                        8 => 16000,
                        9 => 12000,
                        10 => 11025,
                        11 => 8000,
                        12 => 7350,
                        15 => :explicit
                      })

  @channel_config BiMap.new(%{
                    0 => :AOT_specific,
                    1 => 1,
                    2 => 2,
                    3 => 3,
                    4 => 4,
                    5 => 5,
                    6 => 6,
                    7 => 8
                  })

  @frame_length BiMap.new(%{
                  0 => 1024,
                  1 => 960
                })

  @spec aot_id_to_profile(audio_object_type_id_t) :: profile_t
  def aot_id_to_profile(audio_object_type_id),
    do: BiMap.fetch!(@audio_object_type, audio_object_type_id)

  @spec profile_to_aot_id(profile_t) :: audio_object_type_id_t
  def profile_to_aot_id(profile), do: BiMap.fetch_key!(@audio_object_type, profile)

  @spec sampling_frequency_id_to_sample_rate(sampling_frequency_id_t) :: pos_integer
  def sampling_frequency_id_to_sample_rate(sampling_frequency_id),
    do: BiMap.fetch!(@sampling_frequency, sampling_frequency_id)

  @spec sample_rate_to_sampling_frequency_id(sample_rate :: pos_integer | :explicit) ::
          sampling_frequency_id_t
  def sample_rate_to_sampling_frequency_id(sample_rate),
    do: BiMap.fetch_key!(@sampling_frequency, sample_rate)

  @spec channel_config_id_to_channels(channel_config_id_t) :: pos_integer | :AOT_specific
  def channel_config_id_to_channels(channel_config_id),
    do: BiMap.fetch!(@channel_config, channel_config_id)

  @spec channels_to_channel_config_id(channels :: pos_integer | :AOT_specific) ::
          channel_config_id_t
  def channels_to_channel_config_id(channels), do: BiMap.fetch_key!(@channel_config, channels)

  @spec frame_length_id_to_samples_per_frame(frame_length_id_t) :: samples_per_frame_t
  def frame_length_id_to_samples_per_frame(frame_length_id),
    do: BiMap.fetch!(@frame_length, frame_length_id)

  @spec samples_per_frame_to_frame_length_id(samples_per_frame_t) :: pos_integer
  def samples_per_frame_to_frame_length_id(samples_per_frame),
    do: BiMap.fetch_key!(@frame_length, samples_per_frame)
end
