{div, table, tr, td} = React.DOM

SPEED_FACTOR = 1000

create_empty_world = (width, height)-> (({is_alive: false} for c in [0..width]) for r in (row for row in [0..height]))
create_random_world = (width, height)-> (({is_alive: Boolean(Math.round(Math.random() - 0.2))} for c in [0..width]) for r in (row for row in [0..height]))


Cell = React.createClass
    render: ()->
        td
            className: React.addons.classSet
                "cell": true
                "active": @props.is_alive
            onClick: ()=> @props.handleClick @props


Universe = React.createClass
    get_adjanced_cells_coords: (x, y, width, height)->
        ids = []
        lazyProduct(
            [[x + 1, x - 1, x], [y + 1, y - 1, y]],
            (_x, _y) ->
                unless (
                    (_x is x and _y is y) or
                    _x < 0 or
                    _y < 0 or
                    _y >= width or
                    _x >= height
                )
                    ids.push([_x,_y])
        )
        ids

    decide_fate: (cell, row_num, cell_num)->
        coords = @get_adjanced_cells_coords row_num, cell_num, @state.width, @state.height
        alive_adjanced_cells = (@state.world[x][y] for [x, y] in coords when @state.world[x][y].is_alive) or []

        if not cell.is_alive and alive_adjanced_cells.length == 3
            true
        else if cell.is_alive and 2 <= alive_adjanced_cells.length <= 3
            true
        else
            false

    evolve_world: () ->
        console.log 'evolving'
        new_world = []
        for row, row_num in @state.world
            new_world.push row.map (cell, cell_num)=>
                is_alive: @decide_fate cell, row_num, cell_num

        @setState world: new_world

    getInitialState: ()->
        world: create_random_world 5, 5
        width: 5
        height: 5

    componentWillMount: ()->
        $('#start').click ()=>
            window.speed_timeout = setInterval(
                @evolve_world
                SPEED_FACTOR / $('#speed').val()
            )
            $('#speed').attr "disabled", "disabled"
            $('#start').attr "disabled", "disabled"

        $('#stop').click ()=>
            clearTimeout(window.speed_timeout)
            $('#speed').attr "disabled", false
            $('#start').attr "disabled", false

        $('#clear').click ()=>
            @setState world: create_empty_world @state.width, @state.height

        $('#random').click ()=>
            @setState world: create_random_world @state.width, @state.height

        $('#rerender').click ()=>
            clearTimeout(window.speed_timeout)
            width = parseInt $('#world_width').val()
            height = parseInt $('#world_height').val()
            @setState
                world: create_random_world width, height
                width: width
                height: height

    handleCellClick: (cell_props)->
        {is_alive, row_num, cell_num} = cell_props
        new_world = @state.world.slice(0)
        new_world[row_num][cell_num].is_alive = not new_world[row_num][cell_num].is_alive
        @setState world: new_world

    render: () ->
        table
            componentName: "Universe"
            className: "center"
            id: "world"
            @state.world.map (row, row_num)=>
                tr
                    key: row_num
                    row.map (cell, cell_num)=>
                        Cell
                            is_alive: cell.is_alive
                            row_num: row_num
                            cell_num: cell_num
                            key: "#{row_num}_#{cell_num}"
                            handleClick: @handleCellClick

React.renderComponent Universe(), document.getElementById 'universe'
