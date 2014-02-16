# all the imports
from flask import Flask
from flask import render_template
from flask import request

from gardens import SIMPLE_PLANER

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
        world_width=int(request.args.get('world_width', 30)),
        world_height=int(request.args.get('world_height', 30)),
        alive_cells=SIMPLE_PLANER
    )

if __name__ == '__main__':
    app.run()

