module.exports =
  activate: ->
    scrollUp = (view) ->
      firstRow = view.getFirstVisibleScreenRow()
      lastRow = view.getLastVisibleScreenRow()
      currentRow = view.getModel().cursors[0].getBufferRow()
      rowCount = (lastRow - firstRow) - (currentRow - firstRow)

      view.scrollToBufferPosition([lastRow * 2, 0])
      view.getModel().moveCursorDown(rowCount)

    scrollDown = (view) ->
      firstRow = view.getFirstVisibleScreenRow()
      lastRow = view.getLastVisibleScreenRow()
      currentRow = view.getModel().cursors[0].getBufferRow()
      rowCount = (lastRow - firstRow) - (lastRow - currentRow)

      view.scrollToBufferPosition([Math.floor(firstRow / 2), 0])
      view.getModel().moveCursorUp(rowCount)

    atom.workspaceView.eachEditorView (view) ->
      view.command 'ergonomic-key-layout:scroll-up', => scrollUp(view)
      view.command 'ergonomic-key-layout:scroll-down', => scrollDown(view)
