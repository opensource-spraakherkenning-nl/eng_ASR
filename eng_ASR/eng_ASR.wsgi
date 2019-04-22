import sys
import eng_ASR.eng_ASR
import clam.clamservice
application = clam.clamservice.run_wsgi(eng_ASR.eng_ASR)
