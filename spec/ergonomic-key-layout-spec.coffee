{Point} = require 'atom'

describe "ErgonomicKeyLayout", ->
  editor = null
  cursor = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('ergonomic-key-layout')
    waitsForPromise ->
      atom.workspace.open('sample.js')
    runs ->
      editor = atom.workspace.getActiveTextEditor()
      cursor = editor.getLastCursor()
      cursor.setBufferPosition([0, 0])

  activateSelection = ->
    atom.commands.dispatch atom.views.getView(editor), 'ergonomic-key-layout:activate-selection'

  moveRight = ->
    atom.commands.dispatch atom.views.getView(editor), 'ergonomic-key-layout:move-right'

  moveLeft = ->
    atom.commands.dispatch atom.views.getView(editor), 'ergonomic-key-layout:move-left'

  moveUp = ->
    atom.commands.dispatch atom.views.getView(editor), 'ergonomic-key-layout:move-up'

  moveDown = ->
    atom.commands.dispatch atom.views.getView(editor), 'ergonomic-key-layout:move-down'

  expectSelectionAt = (start, end) ->
    expect(cursor.selection.getBufferRange().start).toEqual(new Point(start[0], start[1]))
    expect(cursor.selection.getBufferRange().end).toEqual(new Point(end[0], end[1]))

  expectCursorAt = (point) ->
    expect(cursor.getBufferPosition()).toEqual(new Point(point[0], point[1]))

  describe 'selection is not activated', ->
    beforeEach ->
      cursor.setBufferPosition([6, 8])
      cursor.selection.selectRight(2)

    it 'moves to the right without selecting', ->
      moveRight()

      expect(cursor.selection.isEmpty()).toBeTruthy()
      expectCursorAt([6, 11])

    it 'moves to the left without selecting', ->
      moveLeft()

      expect(cursor.selection.isEmpty()).toBeTruthy()
      expectCursorAt([6, 9])

    it 'moves upwards without selecting', ->
      moveUp()

      expect(cursor.selection.isEmpty()).toBeTruthy()
      expectCursorAt([5, 10])

    it 'moves downwards without selecting', ->
      moveDown()

      expect(cursor.selection.isEmpty()).toBeTruthy()
      expectCursorAt([7, 10])

  describe 'selection is activated', ->
    beforeEach ->
      cursor.setBufferPosition([6, 10])
      activateSelection()

    it 'deactivate the selection by activating on the same position', ->
      activateSelection()
      moveRight()

      expect(cursor.selection.isEmpty()).toBeTruthy()

    it 'reactivate the selection at another position', ->
      moveRight()

      activateSelection()
      moveRight()

      expectSelectionAt([6, 11], [6, 12])

    it 'deactivate the selection when the buffer changed', ->
      editor.setText('new content')
      moveLeft()

      expect(cursor.selection.isEmpty()).toBeTruthy()
      expectCursorAt([0, 10])

    it 'moves to the right while selecting', ->
      moveRight()

      expectSelectionAt([6, 10], [6, 11])
      expectCursorAt([6, 11])

    it 'moves to the left while selecting', ->
      moveLeft()

      expectSelectionAt([6, 9], [6, 10])
      expectCursorAt([6, 9])

    it 'moves upwards while selecting', ->
      moveUp()

      expectSelectionAt([5, 10], [6, 10])
      expectCursorAt([5, 10])

    it 'moves downwards while selecting', ->
      moveDown()

      expectSelectionAt([6, 10], [7, 10])
      expectCursorAt([7, 10])
