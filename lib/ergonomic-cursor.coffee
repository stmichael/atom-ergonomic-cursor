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
      @positionChangeEvent.dispose()
      @contentChangeEvent.dispose()
      @cursor.clearSelection()
      @marker.destroy()
      @activated = false

module.exports =
  activate: ->
    self = @
    atom.commands.add 'atom-text-editor',
      'ergonomic-cursor:activate-selection': ->
        self.getActiveEditor()._incrementalSelection ||= new IncrementalSelection(self.getActiveEditor())
        if self.getActiveEditor()._incrementalSelection.didPositionChange()
          self.deactivateSelection()
          self.activateSelection()
        else
          self.deactivateSelection()
      'ergonomic-cursor:move-right': ->
        self.getActiveEditor().moveCursors (cursor) ->
          cursor.moveRight(1, false)
      'ergonomic-cursor:move-left': ->
        self.getActiveEditor().moveCursors (cursor) ->
          cursor.moveLeft(1, false)
      'ergonomic-cursor:move-up': ->
        self.getActiveEditor().moveCursors (cursor) ->
          cursor.moveUp(1, false)
      'ergonomic-cursor:move-down': ->
        self.getActiveEditor().moveCursors (cursor) ->
          cursor.moveDown(1, false)

  getActiveEditor: ->
    atom.workspace.getActiveTextEditor()

  activateSelection: ->
    @getActiveEditor()._incrementalSelection.activate()

  deactivateSelection: ->
    @getActiveEditor()._incrementalSelection.deactivate()
