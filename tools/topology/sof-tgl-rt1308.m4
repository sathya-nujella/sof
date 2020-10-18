#
# Topology for Tigerlake with rt1308 (x1-SDW link-1) + HDMI + DMIC.
#

# Include topology builder
include(`utils.m4')
include(`dai.m4')
include(`pipeline.m4')
include(`alh.m4')
include(`hda.m4')
include(`platform/intel/dmic.m4')

# Include TLV library
include(`common/tlv.m4')

# Include Token library
include(`sof/tokens.m4')

include(`platform/intel/tgl.m4')

define(DMIC_PDM_CONFIG, ifelse(CHANNELS, `4', ``FOUR_CH_PDM0_PDM1'',
	`ifelse(CHANNELS, `2', ``STEREO_PDM0'', `')'))

DEBUG_START

#
# Define the pipelines
#
# PCM0 ---> volume ----> ALH 2 BE dailink 0
# PCM1 <--- volume <---- ALH 3 BE dailink 1
# PCM2 <--- volume <---- ALH 2 BE dailink 2
# PCM3 <----volume <---- DMIC01
# PCM4 <----volume <---- DMIC16k
# PCM5 ---> volume <---- iDisp1
# PCM6 ---> volume <---- iDisp2
# PCM7 ---> volume <---- iDisp3
# PCM8 ---> volume <---- iDisp4

dnl PIPELINE_PCM_ADD(pipeline,
dnl     pipe id, pcm, max channels, format,
dnl     period, priority, core,
dnl     pcm_min_rate, pcm_max_rate, pipeline_rate,
dnl     time_domain, sched_comp)

# Low Latency playback pipeline 3 on PCM 2 using max 2 channels of s32le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
	3, 2, 2, s32le,
	1000, 0, 0,
	48000, 48000, 48000)

# Passthrough capture pipeline 4 on PCM 3 using max 4 channels.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-capture.m4,
        4, 3, 4, s32le,
        1000, 0, 0,
        48000, 48000, 48000)

# Passthrough capture pipeline 5 on PCM 4 using max 4 channels.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-capture-16khz.m4,
        5, 4, CHANNELS, s16le,
        1000, 0, 0,
        16000, 16000, 16000)

# Low Latency playback pipeline 6 on PCM 5 using max 2 channels of s32le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
	6, 5, 2, s32le,
	1000, 0, 0,
	48000, 48000, 48000)

# Low Latency playback pipeline 7 on PCM 6 using max 2 channels of s32le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
	7, 6, 2, s32le,
	1000, 0, 0,
	48000, 48000, 48000)

# Low Latency playback pipeline 8 on PCM 7 using max 2 channels of s32le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
	8, 7, 2, s32le,
	1000, 0, 0,
	48000, 48000, 48000)

# Low Latency playback pipeline 9 on PCM 8 using max 2 channels of s32le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
        9, 8, 2, s32le,
        1000, 0, 0,
        48000, 48000, 48000)

#
# DAIs configuration
#

dnl DAI_ADD(pipeline,
dnl     pipe id, dai type, dai_index, dai_be,
dnl     buffer, periods, format,
dnl     deadline, priority, core, time_domain)

# playback DAI is ALH(SDW1 PIN2) using 2 periods
# Buffers use s24le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	3, ALH, 0x102, SDW1-Playback,
	PIPELINE_SOURCE_3, 2, s24le,
	1000, 0, 0, SCHEDULE_TIME_DOMAIN_TIMER)

# capture DAI is DMIC01 using 2 periods
# Buffers use s32le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-capture.m4,
        4, DMIC, 0, dmic01,
        PIPELINE_SINK_4, 2, s32le,
        1000, 0, 0, SCHEDULE_TIME_DOMAIN_TIMER)

# capture DAI is DMIC16k using 2 periods
# Buffers use s16le format, with 16 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-capture.m4,
        5, DMIC, 1, dmic16k,
        PIPELINE_SINK_5, 2, s16le,
        1000, 0, 0, SCHEDULE_TIME_DOMAIN_TIMER)

# playback DAI is iDisp1 using 2 periods
# Buffers use s32le format, 1000us deadline on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	6, HDA, 0, iDisp1,
	PIPELINE_SOURCE_6, 2, s32le,
	1000, 0, 0, SCHEDULE_TIME_DOMAIN_TIMER)

# playback DAI is iDisp2 using 2 periods
# Buffers use s32le format, 1000us deadline on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	7, HDA, 1, iDisp2,
	PIPELINE_SOURCE_7, 2, s32le,
	1000, 0, 0, SCHEDULE_TIME_DOMAIN_TIMER)

# playback DAI is iDisp3 using 2 periods
# Buffers use s32le format, 1000us deadline on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	8, HDA, 2, iDisp3,
	PIPELINE_SOURCE_8, 2, s32le,
	1000, 0, 0, SCHEDULE_TIME_DOMAIN_TIMER)

# playback DAI is iDisp4 using 2 periods
# Buffers use s32le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
        9, HDA, 3, iDisp4,
        PIPELINE_SOURCE_9, 2, s32le,
        1000, 0, 0, SCHEDULE_TIME_DOMAIN_TIMER)

# PCM Low Latency, id 0
dnl PCM_PLAYBACK_ADD(name, pcm_id, playback)
PCM_PLAYBACK_ADD(SDW1-speakers, 2, PIPELINE_PCM_3)
PCM_CAPTURE_ADD(DMIC, 3, PIPELINE_PCM_4)
PCM_CAPTURE_ADD(DMIC16kHz, 4, PIPELINE_PCM_5)
PCM_PLAYBACK_ADD(HDMI1, 5, PIPELINE_PCM_6)
PCM_PLAYBACK_ADD(HDMI2, 6, PIPELINE_PCM_7)
PCM_PLAYBACK_ADD(HDMI3, 7, PIPELINE_PCM_8)
PCM_PLAYBACK_ADD(HDMI4, 8, PIPELINE_PCM_9)
#
# BE configurations - overrides config in ACPI if present
#

#ALH dai index = ((link_id << 8) | PDI id)

#ALH SDW1 Pin2 (ID: 2)
DAI_CONFIG(ALH, 0x102, 0, SDW1-Playback,
	ALH_CONFIG(ALH_CONFIG_DATA(ALH, 0x102, 48000, 2)))

# dmic01 (ID: 3)
DAI_CONFIG(DMIC, 0, 1, dmic01,
           DMIC_CONFIG(1, 500000, 4800000, 40, 60, 48000,
                DMIC_WORD_LENGTH(s32le), 400, DMIC, 0,
                PDM_CONFIG(DMIC, 0, FOUR_CH_PDM0_PDM1)))

# dmic16k (ID: 4)
DAI_CONFIG(DMIC, 1, 2, dmic16k,
           DMIC_CONFIG(1, 500000, 4800000, 40, 60, 16000,
                DMIC_WORD_LENGTH(s16le), 400, DMIC, 1,
                PDM_CONFIG(DMIC, 1, DMIC_PDM_CONFIG)))

# 3 HDMI/DP outputs (ID: 5,6,7)
DAI_CONFIG(HDA, 0, 3, iDisp1,
	HDA_CONFIG(HDA_CONFIG_DATA(HDA, 0, 48000, 2)))
DAI_CONFIG(HDA, 1, 4, iDisp2,
	HDA_CONFIG(HDA_CONFIG_DATA(HDA, 1, 48000, 2)))
DAI_CONFIG(HDA, 2, 5, iDisp3,
	HDA_CONFIG(HDA_CONFIG_DATA(HDA, 2, 48000, 2)))
DAI_CONFIG(HDA, 3, 6, iDisp4,
	HDA_CONFIG(HDA_CONFIG_DATA(HDA, 3, 48000, 2)))

DEBUG_END
