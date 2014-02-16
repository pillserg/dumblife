# all the imports
from flask import Flask
from flask import render_template
from flask import request

from gardens import EMPTY_GARDEN

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
    return render_template(
        'game.html',
        world_width=int(request.args.get('world_width', 20)),
        world_height=int(request.args.get('world_height', 20)),
        alive_cells=[]
    )

if __name__ == '__main__':
    app.run()

