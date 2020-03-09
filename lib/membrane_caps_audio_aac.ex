defmodule Membrane.Caps.Audio.AAC do
  @moduledoc """
  Capabilities for [Advanced Audio Codec](https://wiki.multimedia.cx/index.php/Understanding_AAC).

  Conversion functions in this module conform to the [ADTS encapsulation](https://wiki.multimedia.cx/index.php/ADTS).
  """
  @type t :: %__MODULE__{
          profile: :main | :LC | :SSR | :LTP | :HE | :HEv2,
          mpeg_version: 2 | 4,
          sample_rate: pos_integer,
          channels: pos_integer,
          samples_per_frame: 1024 | 960,
          frames_per_buffer: pos_integer,
          encapsulation: :none | :adts
        }

  @enforce_keys [
    :profile,
    :sample_rate,
    :channels
  ]
  defstruct @enforce_keys ++ [samples_per_frame: 1024, frames_per_buffer: 1, packetization: :raw]

  @profile_id BiMap.new(%{
                1 => :main,
                2 => :LC,
                3 => :SSR,
                4 => :LTP
              })

  @sampling_frequency_id BiMap.new(%{
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
                           12 => 7350
                         })

  @channel_setup_id BiMap.new(%{
                      0 => :unknown,
                      1 => 1,
                      2 => 2,
                      3 => 3,
                      4 => 4,
                      5 => 5,
                      6 => 6,
                      7 => 8
                    })

  @frame_length_id BiMap.new(%{
                     0 => 1024,
                     1 => 960
                   })

  @spec profile_id_to_profile(profile_id :: pos_integer) ::
          {:ok, :main | :LC | :SSR | :LTP} | :error
  def profile_id_to_profile(profile_id), do: BiMap.fetch(@profile_id, profile_id)

  @spec profile_id_to_profile(:main | :LC | :SSR | :LTP) :: {:ok, profile_id :: pos_integer}
  @spec profile_id_to_profile(atom) :: :error
  def profile_to_profile_id(profile), do: BiMap.fetch_key(@profile_id, profile)

  @spec sampling_frequency_id_to_sample_rate(sampling_frequency_id :: non_neg_integer) ::
          {:ok, pos_integer} | :error
  def sampling_frequency_id_to_sample_rate(pos_integer),
    do: BiMap.fetch(@sampling_frequency_id, sfi)

  @spec sample_rate_to_sampling_frequency_id(sample_rate :: pos_integer) ::
          {:ok, non_neg_integer} | :error
  def sample_rate_to_sampling_frequency_id(sample_rate),
    do: BiMap.fetch_key(@sampling_frequency_id, sample_rate)

  @spec channel_setup_id_to_channels(channel_setup_id :: non_neg_integer) ::
          {:ok, pos_integer | :unknown} | :error
  def channel_setup_id_to_channels(channel_setup_id),
    do: BiMap.fetch(@channel_setup_id, channel_setup_id)

  @spec channels_to_channel_setup_id(channels :: pos_integer | :unknown) ::
          {:ok, non_neg_integer} | :error
  def channels_to_channel_setup_id(channels), do: BiMap.fetch_key(@channel_setup_id, channels)

  @spec frame_length_id_to_samples_per_frame(frame_length_id :: non_neg_integer) ::
          {:ok, pos_integer} | :error
  def frame_length_id_to_samples_per_frame(frame_length_id),
    do: BiMap.fetch(@frame_length_id, frame_length_id)

  @spec samples_per_frame_to_frame_length_id(pos_integer) :: {:ok, pos_integer} | :error
  def samples_per_frame_to_frame_length_id(samples_per_frame),
    do: BiMap.fetch_key(@frame_length_id, samples_per_frame)
end
