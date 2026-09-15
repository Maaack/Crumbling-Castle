import wave
import numpy as np
import sys

wave_file = ""
try:
    wave_file = sys.argv[1]
except IndexError:
    print('Must include a file path as argument.')
    exit(1)

with wave.open(wave_file, "rb") as wf:
    nchannels = wf.getnchannels()    # Number of channels (1=mono, 2=stereo)  
    sampwidth = wf.getsampwidth()    # Bytes per sample (e.g., 2 for 16-bit)  
    framerate = wf.getframerate()    # Sample rate (Hz)  
    nframes = wf.getnframes()        # Total samples  
    comptype = wf.getcomptype()      # Compression type (usually "NONE" for PCM)  
    compname = wf.getcompname()      # Compression name  
    raw_data = wf.readframes(nframes)  # Bytes object with audio samples  

