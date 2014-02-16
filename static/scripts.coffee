ACTIVE_CLS = 'active'
SPEED_FACTOR = 1000
window.speed_timeout = null
window.iteration = 0

get_speed = () -> $('#speed').val()

toggle_cell = (e) ->
    $cell = $(this)
    $cell.toggleClass(ACTIVE_CLS)

activate_cell = ($cell) -> $cell.addClass ACTIVE_CLS
deactivate_cell = ($cell) -> $cell.removeClass ACTIVE_CLS
is_alive = ($cell) -> if $cell.hasClass(ACTIVE_CLS) then true else false

get_cell_coords = (cell) ->
    [_,x,y] = cell.id.split '_'
    [parseInt(x), parseInt(y)]


get_adjanced_cells = (cell) ->
    [x, y] = get_cell_coords(cell)
    ids = []
    lazyProduct(
        [[x + 1, x - 1, x], [y + 1, y - 1, y]],
        (x, y) -> ids.push("#cell_#{x}_#{y}")
    )
    $(ids.join(',')).not(cell)


decide_fate = (cell)->
    adjanced_cells = $(cell).data('adjanced_cells')
    alive_adjanced_cells = (a_cell for a_cell in adjanced_cells when is_alive($ a_cell)) or []

    if not is_alive($ cell) and alive_adjanced_cells.length == 3
        true
    else if is_alive($ cell) and 2 <= alive_adjanced_cells.length <= 3
        true
    else
        false


init = (world) ->
    for cell in world.find('.cell')
        ($ cell).data 'adjanced_cells', get_adjanced_cells(cell)


evolve = () ->
    console.log("evolving world, iteraition: #{window.iteration}")
    world = $ ('#world')

    for cell in world.find('.cell')
        $(cell).data('is_alive_at_next_step', decide_fate cell)

    for cell in world.find('.cell')
        if $(cell).data('is_alive_at_next_step')
            activate_cell $(cell)
        else
            deactivate_cell $(cell)


    window.speed_timeout = setTimeout(evolve, SPEED_FACTOR / get_speed())
    window.iteration++


init $ '#world'


$('#universe').on 'click', '#world .cell',  toggle_cell
$('#start').click ()-> evolve()
$('#stop').click ()-> clearTimeout(window.speed_timeout)



