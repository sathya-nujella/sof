#
# Topology for generic Baytrail board with no codec.
#

# Include topology builder
include(`pipeline.m4')
include(`utils.m4')
include(`dai.m4')

# Include TLV library
include(`common/tlv.m4')

# Include Token library
include(`sof/tokens.m4')

# Include Baytrail DSP configuration
include(`dsps/byt.m4')

#
# Define the pipelines
#
# PCM0 ----> volume ---------------+
#                                  |--low latency mixer ----> volume ---->  SSP2
# PCM2 ----> SRC -----> volume ----+
#                                  |
#           Tone -----> volume ----+
#
# PCM1 <---- Volume <---- SSP2
#

# Low Latency playback pipeline 1 on PCM 0 using max 2 channels of s32le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-low-latency-playback.m4,
	1, 0, 2, s32le,
	48, 1000, 0, 0)

# Low Latency capture pipeline 2 on PCM 0 using max 2 channels of s32le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-low-latency-capture.m4,
	2, 0, 2, s32le,
	48, 1000, 0, 0)

# PCM Media Playback pipeline 3 on PCM 1 using max 2 channels of s32le.
# Schedule 192 frames per 4000us deadline on core 0 with priority 1
PIPELINE_PCM_ADD(sof/pipe-pcm-media.m4,
	3, 1, 2, s32le,
	192, 4000, 1, 0)

# Tone Playback pipeline 5 using max 2 channels of s32le.
# Schedule 192 frames per 4000us deadline on core 0 with priority 2
PIPELINE_ADD(sof/pipe-tone.m4,
	5, 2, s32le,
	192, 4000, 2, 0)

# Connect pipelines together
SectionGraph."pipe-byt-nocodec" {
	index "0"

	lines [
		# media 0
		dapm(PIPELINE_MIXER_1, PIPELINE_SOURCE_3)
		#tone
		dapm(PIPELINE_MIXER_1, PIPELINE_SOURCE_5)
	]
}

#
# DAI configuration
#
# SSP port 2 is our only pipeline DAI
#

# playback DAI is SSP2 using 2 periods
# Buffers use s24le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	1, SSP, 2, NoCodec,
	PIPELINE_SOURCE_1, 2, s24le,
	48, 1000, 0, 0)

# capture DAI is SSP2 using 2 periods
# Buffers use s24le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-capture.m4,
	2, SSP, 2, NoCodec,
	PIPELINE_SINK_2, 2, s24le,
	48, 1000, 0, 0)

# PCM Low Latency
PCM_DUPLEX_ADD(Low Latency, 6, 0, 0, PIPELINE_PCM_1, PIPELINE_PCM_2)

#
# BE configurations - overrides config in ACPI if present
#
DAI_CONFIG(SSP, 2, 0, NoCodec,
	   SSP_CONFIG(I2S, DAI_CLOCK(mclk, 19200000, codec_mclk_in),
		      DAI_CLOCK(bclk, 2400000, codec_slave),
		      DAI_CLOCK(fsync, 48000, codec_slave),
		      DAI_TDM(2, 25, 3, 3),
		      SSP_CONFIG_DATA(SSP, 2, 24)))
