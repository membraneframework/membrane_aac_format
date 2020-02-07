defmodule Membrane.Caps.AAC do
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

  def profile_id_to_profile(profile_id), do: BiMap.fetch(@profile_id, profile_id)

  def profile_to_profile_id(profile), do: BiMap.fetch_key(@profile_id, profile)

  def sampling_frequency_id_to_sample_rate(sfi), do: BiMap.fetch(@sampling_frequency_id, sfi)

  def sample_rate_to_sampling_frequency_id(sample_rate),
    do: BiMap.fetch_key(@sampling_frequency_id, sample_rate)

  def channel_setup_id_to_channels(channel_setup_id),
    do: BiMap.fetch(@channel_setup_id, channel_setup_id)

  def channels_to_channel_setup_id(channels), do: BiMap.fetch_key(@channel_setup_id, channels)

  def frame_length_id_to_samples_per_frame(frame_length_id),
    do: BiMap.fetch(@frame_length_id, frame_length_id)

  def samples_per_frame_to_frame_length_id(samples_per_frame),
    do: BiMap.fetch_key(@frame_length_id, samples_per_frame)
end
