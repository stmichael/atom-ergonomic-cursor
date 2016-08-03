{Point} = require 'atom'

describe "Ergonomic cursor movement", ->
  editor = null
  cursor = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('ergonomic-cursor')
    waitsForPromise ->
      atom.workspace.open('sample.js')
    runs ->
      editor = atom.workspace.getActiveTextEditor()
      cursor = editor.getLastCursor()
      cursor.setBufferPosition([0, 0])

  activateSelection = ->
    atom.commands.dispatch atom.views.getView(editor), 'ergonomic-cursor:activate-selection'

  moveRight = ->
    atom.commands.dispatch atom.views.getView(editor), 'ergonomic-cursor:move-right'

  moveLeft = ->
    atom.commands.dispatch atom.views.getView(editor), 'ergonomic-cursor:move-left'

  moveUp = ->
    atom.commands.dispatch atom.views.getView(editor), 'ergonomic-cursor:move-up'

  moveDown = ->
    atom.commands.dispatch atom.views.getView(editor), 'ergonomic-cursor:move-down'

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

    it 'deactivate the selection by activating on the same position', ->
      activateSelection()
      activateSelection()
      moveRight()

      expect(cursor.selection.isEmpty()).toBeTruthy()

    it 'reactivate the selection at another position', ->
      activateSelection()
      moveRight()

      activateSelection()
      moveRight()

      expectSelectionAt([6, 11], [6, 12])

    it 'deactivate the selection if the buffer changed', ->
      activateSelection()
      editor.setText('new content')
      moveLeft()

      expect(cursor.selection.isEmpty()).toBeTruthy()
      expectCursorAt([0, 10])

    it 'deactivates the selection if text has been replaced', ->
      cursor.setBufferPosition([0, 0])
      activateSelection()
      atom.commands.dispatch atom.views.getView(editor), 'editor:move-to-end-of-word'
      console.log 'make change'
      cursor.selection.insertText 'a'
      console.log editor.getText()

      expect(cursor.selection.isEmpty()).toBeTruthy()
      expectCursorAt([0, 1])

    it 'moves to the right while selecting', ->
      activateSelection()
      moveRight()

      expectSelectionAt([6, 10], [6, 11])
      expectCursorAt([6, 11])

    it 'moves to the left while selecting', ->
      activateSelection()
      moveLeft()

      expectSelectionAt([6, 9], [6, 10])
      expectCursorAt([6, 9])

    it 'moves upwards while selecting', ->
      activateSelection()
      moveUp()

      expectSelectionAt([5, 10], [6, 10])
      expectCursorAt([5, 10])

    it 'moves downwards while selecting', ->
      activateSelection()
      moveDown()

      expectSelectionAt([6, 10], [7, 10])
      expectCursorAt([7, 10])
