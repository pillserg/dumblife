# all the imports
from flask import Flask
from flask import render_template


app = Flask(__name__)
app.config.from_object(__name__)

app.config.update(dict(
    DEBUG=True,
    SECRET_KEY='development key',
    USERNAME='admin',
    PASSWORD='default'
))


@app.route('/')
def start_game():
    return render_template('game.html', world_width=10, world_height=10)

if __name__ == '__main__':
    app.run()

