"""
Converts WAV file into an array of floats (-1.0, 1.0) and writes them to a binary file.

Based on the tutorial:
https://www.w3reference.com/blog/python-write-a-wav-file-into-numpy-float-array/

Modified to also include downsampling, as referenced:
https://stackoverflow.com/a/20322495

"""
import wave
import numpy as np
import sys
import math

wave_file_path = ""
target_file_path = ""
downsample = 0
try:
    wave_file_path = sys.argv[1]
except IndexError:
    print('Must include a wave file path as argument.')
    exit(1)

try:
    target_file_path = sys.argv[2]
except IndexError:
    print('Must include a target file path as argument.')
    exit(1)

try:
    downsample = int(sys.argv[3])
except IndexError:
    pass

with wave.open(wave_file_path, "rb") as wf:
    nchannels = wf.getnchannels()    # Number of channels (1=mono, 2=stereo)  
    sampwidth = wf.getsampwidth()    # Bytes per sample (e.g., 2 for 16-bit)  
    framerate = wf.getframerate()    # Sample rate (Hz)  
    nframes = wf.getnframes()        # Total samples  
    comptype = wf.getcomptype()      # Compression type (usually "NONE" for PCM)  
    compname = wf.getcompname()      # Compression name  
    raw_data = wf.readframes(nframes)  # Bytes object with audio samples  

    if sampwidth == 1:  
        dtype = np.uint8  
    elif sampwidth == 2:  
        dtype = np.int16  
    elif sampwidth == 4:  
        dtype = np.int32  # Assumes 32-bit integer (common for PCM)  
    else:  
        raise ValueError(f"Unsupported sample width: {sampwidth} bytes")  
    
    audio_int = np.frombuffer(raw_data, dtype=dtype)  # Integer array  
    audio_int = audio_int.reshape(-1, nchannels)  # Shape: (nframes, nchannels) 
    if sampwidth == 1:  
        # 8-bit unsigned: [0, 255] → [-1.0, 1.0]  
        audio_float = (audio_int - 128) / 128.0  
    else:  
        # 16/32-bit signed: Divide by max integer value  
        max_val = np.iinfo(dtype).max  # e.g., 32767 for int16  
        audio_float = audio_int.astype(np.float32) / max_val

    if downsample > 0:
        pad_size = math.ceil(float(audio_float.size)/downsample)*downsample - audio_float.size
        audio_float = np.append(audio_float, np.zeros(pad_size))
        audio_float = audio_float.reshape(-1, downsample)
        audio_float = audio_float.reshape(-1, downsample).mean(axis=1)
    print("Writing ", audio_float.size, " entries.")
    np.save(target_file_path, audio_float)
