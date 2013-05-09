$(document).ready () =>
  isParent = (parent, pathname) ->
    console.log parent, pathname
    if pathname? and parent?
      pathname.startsWith(parent) and parent.endsWith('/') or parent is ''
    else
      false

  updateLeafs = (parent) ->
    $(parent).find('li').each (index, elem) =>
      elem = $(elem)
      elem.toggleClass('loading')
      $.post '/leaf', {pathname: elem.attr('data-pathname')}, (data) =>
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
    content.load '/files', {pathname: pathname}, () =>
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
      parent.load '/list', {pathname: parent.attr('data-pathname')}, () =>
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
    $('li').filter(() -> isParent(pathname, $(this).attr('data-pathname')) or pathname is $(this).attr('data-pathname')).children('input[type="checkbox"]').prop 'checked', true
    $.post '/add', {pathname: pathname}

  removePath = (pathname) ->
    $('li').filter(() -> isParent($(this).attr('data-pathname'), pathname)).children('input[type="checkbox"]').prop 'checked', false
    $('li[data-pathname="'+pathname+'"] input[type="checkbox"]').prop 'checked', false
    $.post '/remove', {pathname: pathname}

  loadFolder $('.is-root').attr('data-pathname')
