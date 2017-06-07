import RPi.GPIO as GPIO
import subprocess

MUSIC_EN = 11
MUSIC_SEL = 13
AUDIOS = {False: 'bgm.wav', True: 'gg.wav'}

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)

GPIO.setup(MUSIC_EN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(MUSIC_SEL, GPIO.IN, pull_up_down=GPIO.PUD_UP)

player = None
current_audio = ''

while True:
	enable = GPIO.input(MUSIC_EN)
	sel = GPIO.input(MUSIC_SEL)

	if not enable and player and player.poll() == None:
		player.kill()
		player = None
		current_audio = ''
		print 'killed'

	audio = AUDIOS[sel]
	if current_audio != audio and enable:
		if player and player.poll() == None:
			player.kill()
		player = subprocess.Popen(['/usr/bin/mplayer', audio])
		current_audio = audio
		print audio
