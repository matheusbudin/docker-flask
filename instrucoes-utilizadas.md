criar aplicações com flask e containerizar a aplicação


fluxo docker:

//arquivo texto (Dockerfile) > build (imagem) > container (processo em execucao da imagem)

COPY ./app . #leva para o diretorio atual

depois de configurar o main.py e o dockerfile é necessário "buildar a imagem" com os comandos abaixo:

-t significa tag, dar um nome para a imagem, o ponto ao final é o parametro para dizer aonde está o dockerfile, . significa que está na raiz

- docker build -t my-py:v1 .

para ver a imagem criada:

docker imagem ls

para executar o container:

docker run nome_container:v1   (v1 é a tag ou versao)

docker run -ti my-py:v2 sh (-ti traz um terminal interativo, sh - shell abrirá um terminal, poderia ser o bash tb)

para listar os containers:

docker ps

docker ps -a


quando mudar o conteudo do dockerfile, é necessário rebuildar a imagem

executar: flask --app nome_arquivo run




Flask verifica se tem variaveis de ambiente:


export FLASK_APP=main.py
export FLASK_DEBUG=1



depois de buildar com todas as configs necessárias é preciso mapear portas de acesso:

EXPOSE 5000 (expoe a porta 5000 do flask):
docker run -p 3000:5000 my-py:v7 -> mapeia a 3000 da maquina com a 5000 do container


VOLUME [ "/usr/flask/application" ] -> expondo volume

VOLUME [ "/usr/flask/application/logs"] -> digamos q ele crie uma pasta de logs pra nos, podemos persistir esse volume tb


docker inspect nome_imagem

para mapear volumes:

docker run -p 80:5000 -v $(pwd)/app/flask/application my-py:v10 (pwd é comando linux, só funciona no bash) $(pwd) == #PWD no powershell

docker run -p 80:5000 -d -v  $(pwd)/app/flask/application my-py:v10  (-d é o detached)



bonus: subir a imagem para o docker hub (repositorio de imagens, gratuito)

mudar o nome com padrao:

docker build -t matheusbudin/flask/hello-from-docker:v1 .
docker login

docker push nome_imagem

depois de subir a imagem, pode apagar tudo local 


docker rm -f $(docker ps -qa) _> o parenteses no linux concatena, entao no powershell é só digitar tudo junto

docker system prune -af --volume (limpa tudo da maquina q esteja relacionado ao docker


docker pull nome-imagem-repositorio:v1
docker inspect matheusbudin/flask-hello-from-docker:v1
(o inspect seria uma documentação)
docker run nome-imagem-repositorio:v1


docker run -v $PWD:/usr/flask/application -p 80:5000 matheusbudin/flask-hello-from-docker:v1 (deu erro dizendo q o main.py nao existe)

para resolver esse erro: criar um main.py

no main.py escrever:
from flask import Flask

app = Flask(__name__)

@app.route("/<username>")
def hello(username):
    return f'Hello {username}'

e salvar

testar no 127.0.0.1/username


instrução para reescrever variavel por terminal (no caso de main.py -> app.py)

docker run -v $(pwd):usr/flask/application -p 80:5000 -e FLASK_APP=app.py matheusbudin/flask-hello-from-docker:v1