import wave
import numpy as np
import sys

wave_file_path = ""
try:
    wave_file_path = sys.argv[1]
except IndexError:
    print('Must include a file path as argument.')
    exit(1)

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
