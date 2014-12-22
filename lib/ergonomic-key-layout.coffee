{Point} = require('atom')

class IncrementalSelection
  constructor: (@editor) ->
    @cursor = @editor.getLastCursor()
    @activated = false

  activate: ->
    @marker = @editor.markBufferPosition(@editor.getCursorBufferPosition())
    self = @
    @positionChangeEvent = @cursor.onDidChangePosition ->
      a = self.marker.getHeadBufferPosition()
      b = self.cursor.getBufferPosition()
      self.cursor.selection.setBufferRange([a, b], reversed: Point.min(a, b) is b)
    @contentChangeEvent = @editor.onDidChange ->
      self.deactivate()
    @activated = true

  didPositionChange: ->
    !@activated || !@marker.getHeadBufferPosition().isEqual(@cursor.getBufferPosition())

  deactivate: ->
    if @activated
      @cursor.clearSelection()
      @cursor.selection.screenRangeChanged(@marker)
      @marker.destroy()
      @positionChangeEvent.dispose()
      @contentChangeEvent.dispose()
      @activated = false

module.exports =
  activate: ->
    self = @
    atom.commands.add 'atom-text-editor',
      'ergonomic-key-layout:activate-selection': ->
        self.getActiveEditor()._incrementalSelection ||= new IncrementalSelection(self.getActiveEditor())
        if self.getActiveEditor()._incrementalSelection.didPositionChange()
          self.deactivateSelection()
          self.activateSelection()
        else
          self.deactivateSelection()
      'ergonomic-key-layout:move-right': ->
        self.getActiveEditor().moveCursors (cursor) ->
          cursor.moveRight(1, false)
      'ergonomic-key-layout:move-left': ->
        self.getActiveEditor().moveCursors (cursor) ->
          cursor.moveLeft(1, false)
      'ergonomic-key-layout:move-up': ->
        self.getActiveEditor().moveCursors (cursor) ->
          cursor.moveUp(1, false)
      'ergonomic-key-layout:move-down': ->
        self.getActiveEditor().moveCursors (cursor) ->
          cursor.moveDown(1, false)

  getActiveEditor: ->
    atom.workspace.getActiveTextEditor()

  activateSelection: ->
    @getActiveEditor()._incrementalSelection.activate()

  deactivateSelection: ->
    @getActiveEditor()._incrementalSelection.deactivate()
