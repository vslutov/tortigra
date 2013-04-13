$(document).ready () =>
  updateLeafs = (parent) ->
    $(parent).find('li').each (index, elem) =>
      elem = $(elem)
      elem.toggleClass('loading')
      $.post '/leaf', {dirname: elem.attr('data-dirname')}, (data) =>
        elem.toggleClass('loading')
        if data is 'leaf' then elem.addClass 'leaf' 

  expandClick = (e) ->
    parent = $(e.currentTarget).parent()
    if parent.hasClass('leaf')
      return null
    toggleNode parent

  loadFolder = (dirname) ->
    $('.tree .active').removeClass 'active'
    node = $(".tree li[data-dirname='" + dirname + "']")
    node.addClass 'active'
    if not node.hasClass('opened')
      toggleNode node
    $('#content').load '/files', {dirname: dirname}, () =>
      $('#content li').bind 'click', (e) =>
        elem = $(e.currentTarget)
        if elem.attr('data-type') is 'folder'
          loadFolder elem.attr('data-pathname')

  toggleNode = (parent) ->
    parent = $(parent)
    parent.toggleClass 'opened'
    if parent.hasClass('opened') and not parent.hasClass('loaded')
      parent.toggleClass 'loading'
      parent.load '/list', {dirname: parent.attr('data-dirname')}, () =>
        parent.toggleClass 'loading'
        parent.addClass 'loaded'
        parent.find('.expand').bind 'click', expandClick
        parent.find('.content').bind 'click', (e) =>
          loadFolder $(e.currentTarget).parent().attr('data-dirname')
        updateLeafs parent



  toggleNode $('.is-root')
