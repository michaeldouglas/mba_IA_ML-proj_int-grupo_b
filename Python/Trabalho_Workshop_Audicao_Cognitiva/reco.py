import speech_recognition as sr
import pyttsx3

def change_voice(engine, language, gender='VoiceGenderFemale'):
    for voice in engine.getProperty('voices'):
        if language in voice.languages and gender == voice.gender:
            engine.setProperty('voice', voice.id)
            return True

    raise RuntimeError("Language '{}' for gender '{}' not found".format(language, gender))

# Função para sintetizar o áudio a ser reproduzido
def speak(audio):
    engine = pyttsx3.init()
    rate = engine.getProperty('rate')
    volume = engine.getProperty('volume')

    change_voice(engine, "pt_BR", "VoiceGenderFemale")
    engine.setProperty('rate', rate-100)
    engine.setProperty('volume', volume+0.50)
    engine.say(audio)
    engine.runAndWait()

# Iniciando o reconhecedor de voz
r = sr.Recognizer()

# Obtendo o áudio do microfone
with sr.Microphone() as source:
    print("Diga em que área posso ajudá-lo: Vendas, Aluguel, Administrativo ou Financeiro?")
    speak("Diga em que área posso ajudá-lo: Vendas, Aluguel, Administrativo ou Financeiro?")
    audio = r.listen(source)

# Reconhecendo o áudio
try:
    text = r.recognize_google(audio, language='pt-BR')
    print("Você disse: ", text)

    # Verificando a área solicitada
    if "vendas" in text.lower():
        print("Ótimo, vou transferir você para um de nossos corretores de vendas.")
        speak("Ótimo, vou transferir você para um de nossos corretores de vendas.")
    elif "aluguel" in text.lower():
        print("Entendido, vou transferir você para um de nossos representantes de aluguel.")
        speak("Entendido, vou transferir você para um de nossos representantes de aluguel.")
    elif "administrativo" in text.lower():
        print("Compreendido, vou transferir você para a área administrativa.")
        speak("Compreendido, vou transferir você para a área administrativa.")
    elif "financeiro" in text.lower():
        print("Entendido, vou transferir você para a área financeira.")
        speak("Entendido, vou transferir você para a área financeira.")
    else:
        print("Desculpe, não entendi. Por favor, tente novamente.")
        speak("Desculpe, não entendi. Por favor, tente novamente.")

except sr.UnknownValueError:
    print("Não foi possível reconhecer o áudio. Por favor, tente novamente.")
    speak("Não foi possível reconhecer o áudio. Por favor, tente novamente.")
except sr.RequestError as e:
    print("Erro ao reconhecer a fala; {0}".format(e))
    speak("Erro ao reconhecer a fala; {0}".format(e))