ACTIVE_CLS = 'active'

toggle_cell = (e) ->
    cell = $(this)
    cell.toggleClass(ACTIVE_CLS)


evolve = () ->
    cells = $('.cell')
    console.log(cells.length)


init = (world) ->
    cells = world.find('.cell')
    for cell in cells
        console.log cell.id

init $ '#world'

evolve(world)



$('.cell').click toggle_cell


