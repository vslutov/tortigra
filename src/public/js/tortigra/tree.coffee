$(document).ready () =>
  updateLeafs = (parent) ->
    $(parent).find('li').each (index, elem) =>
      elem = $(elem)
      elem.toggleClass('loading')
      $.post '/leaf', {dirname: elem.attr('data-pathname')}, (data) =>
        elem.toggleClass('loading')
        if data is 'leaf' then elem.addClass 'leaf' 

  expandClick = (e) ->
    parent = $(e.currentTarget).parent()
    if parent.hasClass('leaf')
      return null
    toggleNode parent

  loadFolder = (pathname) ->
    $('.tree .active').removeClass 'active'
    node = $(".tree li[data-pathname='" + pathname + "']")
    content = $('#content')
    node.addClass 'active'
    if not node.hasClass('opened')
      toggleNode node
    content.load '/files', {dirname: pathname}, () =>
      content.find('.content').bind 'click', (e) =>
        elem = $(e.currentTarget).parent()
        if elem.attr('data-type') is 'folder'
          loadFolder elem.attr('data-pathname')
      content.find('input[type="checkbox"]').on 'change', pathBoxClick

  toggleNode = (parent) ->
    parent = $(parent)
    parent.toggleClass 'opened'
    if parent.hasClass('opened') and not parent.hasClass('loaded')
      parent.toggleClass 'loading'
      parent.load '/list', {dirname: parent.attr('data-pathname')}, () =>
        parent.toggleClass 'loading'
        parent.addClass 'loaded'
        parent.find('.expand').bind 'click', expandClick
        parent.find('.content').bind 'click', (e) =>
          loadFolder $(e.currentTarget).parent().attr('data-pathname')
        parent.find('input[type="checkbox"]').on 'change', pathBoxClick
        updateLeafs parent

  pathBoxClick = (e) ->
    elem = $(e.currentTarget)
    if elem.is(':checked')
      addPath elem.parent().attr('data-pathname')
    else
      removePath elem.parent().attr('data-pathname')

  addPath = (pathname) ->
    $('li[data-pathname="'+pathname+'"] input[type="checkbox"]').prop 'checked', true
    console.log $('li[data-pathname="'+pathname+'"] input[type="checkbox"]')
    $.post '/add', {pathname: pathname}

  removePath = (pathname) ->
    $('li[data-pathname="'+pathname+'"] input[type="checkbox"]').prop 'checked', false
    $.post '/remove', {pathname: pathname}

  loadFolder $('.is-root').attr('data-pathname')
