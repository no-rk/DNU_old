class EditorsController < ApplicationController
  def map
    @rokume = <<'ROKUME'
- name: MAP1
  caption: |-
    六命のマップを再現してみた。
  attributes:
    - x: 1
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 3
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 4
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 5
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 6
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 7
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 8
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 9
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 10
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 11
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 12
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 13
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 14
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 15
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 16
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 17
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 18
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 20
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 21
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 22
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 23
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 24
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 25
      landform: water
      collision: true
      opacity: 0
    - x: 1
      y: 26
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 3
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 4
      landform: mountain
      collision: false
      opacity: 2
    - x: 2
      y: 5
      landform: mountain
      collision: false
      opacity: 2
    - x: 2
      y: 6
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 7
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 8
      landform: mountain
      collision: false
      opacity: 2
    - x: 2
      y: 9
      landform: mountain
      collision: false
      opacity: 2
    - x: 2
      y: 10
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 11
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 12
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 13
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 14
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 15
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 16
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 17
      landform: mountain
      collision: false
      opacity: 2
    - x: 2
      y: 18
      landform: mountain
      collision: false
      opacity: 2
    - x: 2
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 20
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 21
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 22
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 23
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 24
      landform: desert
      collision: false
      opacity: 0
    - x: 2
      y: 25
      landform: water
      collision: true
      opacity: 0
    - x: 2
      y: 26
      landform: water
      collision: true
      opacity: 0
    - x: 3
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 3
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 3
      y: 3
      landform: mountain
      collision: false
      opacity: 2
    - x: 3
      y: 4
      landform: mountain
      collision: false
      opacity: 2
    - x: 3
      y: 5
      landform: desert
      collision: false
      opacity: 0
    - x: 3
      y: 6
      landform: desert
      collision: false
      opacity: 0
    - x: 3
      y: 7
      landform: plain
      collision: false
      opacity: 0
    - x: 3
      y: 8
      landform: desert
      collision: false
      opacity: 0
    - x: 3
      y: 9
      landform: desert
      collision: false
      opacity: 0
    - x: 3
      y: 10
      landform: mountain
      collision: false
      opacity: 2
    - x: 3
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 3
      y: 12
      landform: water
      collision: true
      opacity: 0
    - x: 3
      y: 13
      landform: water
      collision: true
      opacity: 0
    - x: 3
      y: 14
      landform: water
      collision: true
      opacity: 0
    - x: 3
      y: 15
      landform: water
      collision: true
      opacity: 0
    - x: 3
      y: 16
      landform: mountain
      collision: false
      opacity: 2
    - x: 3
      y: 17
      landform: mountain
      collision: false
      opacity: 2
    - x: 3
      y: 18
      landform: mountain
      collision: false
      opacity: 2
    - x: 3
      y: 19
      landform: mountain
      collision: false
      opacity: 2
    - x: 3
      y: 20
      landform: mountain
      collision: false
      opacity: 2
    - x: 3
      y: 21
      landform: mountain
      collision: false
      opacity: 2
    - x: 3
      y: 22
      landform: water
      collision: true
      opacity: 0
    - x: 3
      y: 23
      landform: desert
      collision: false
      opacity: 0
    - x: 3
      y: 24
      landform: desert
      collision: false
      opacity: 0
    - x: 3
      y: 25
      landform: desert
      collision: false
      opacity: 0
    - x: 3
      y: 26
      landform: water
      collision: true
      opacity: 0
    - x: 4
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 4
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 4
      y: 3
      landform: water
      collision: true
      opacity: 0
    - x: 4
      y: 4
      landform: forest
      collision: false
      opacity: 1
    - x: 4
      y: 5
      landform: plain
      collision: false
      opacity: 0
    - x: 4
      y: 6
      landform: water
      collision: true
      opacity: 0
    - x: 4
      y: 7
      landform: water
      collision: true
      opacity: 0
    - x: 4
      y: 8
      landform: forest
      collision: false
      opacity: 1
    - x: 4
      y: 9
      landform: plain
      collision: false
      opacity: 0
    - x: 4
      y: 10
      landform: plain
      collision: false
      opacity: 0
    - x: 4
      y: 11
      landform: desert
      collision: false
      opacity: 0
    - x: 4
      y: 12
      landform: mountain
      collision: false
      opacity: 2
    - x: 4
      y: 13
      landform: mountain
      collision: false
      opacity: 2
    - x: 4
      y: 14
      landform: water
      collision: true
      opacity: 0
    - x: 4
      y: 15
      landform: mountain
      collision: false
      opacity: 2
    - x: 4
      y: 16
      landform: mountain
      collision: false
      opacity: 2
    - x: 4
      y: 17
      landform: mountain
      collision: false
      opacity: 2
    - x: 4
      y: 18
      landform: water
      collision: true
      opacity: 0
    - x: 4
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 4
      y: 20
      landform: mountain
      collision: false
      opacity: 2
    - x: 4
      y: 21
      landform: desert
      collision: false
      opacity: 0
    - x: 4
      y: 22
      landform: desert
      collision: false
      opacity: 0
    - x: 4
      y: 23
      landform: desert
      collision: false
      opacity: 0
    - x: 4
      y: 24
      landform: town
      collision: false
      opacity: 0
    - x: 4
      y: 25
      landform: desert
      collision: false
      opacity: 0
    - x: 4
      y: 26
      landform: water
      collision: true
      opacity: 0
    - x: 5
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 5
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 5
      y: 3
      landform: water
      collision: true
      opacity: 0
    - x: 5
      y: 4
      landform: forest
      collision: false
      opacity: 1
    - x: 5
      y: 5
      landform: plain
      collision: false
      opacity: 0
    - x: 5
      y: 6
      landform: water
      collision: true
      opacity: 0
    - x: 5
      y: 7
      landform: forest
      collision: false
      opacity: 1
    - x: 5
      y: 8
      landform: forest
      collision: false
      opacity: 1
    - x: 5
      y: 9
      landform: forest
      collision: false
      opacity: 1
    - x: 5
      y: 10
      landform: plain
      collision: false
      opacity: 0
    - x: 5
      y: 11
      landform: plain
      collision: false
      opacity: 0
    - x: 5
      y: 12
      landform: plain
      collision: false
      opacity: 0
    - x: 5
      y: 13
      landform: desert
      collision: false
      opacity: 0
    - x: 5
      y: 14
      landform: mountain
      collision: false
      opacity: 2
    - x: 5
      y: 15
      landform: mountain
      collision: false
      opacity: 2
    - x: 5
      y: 16
      landform: mountain
      collision: false
      opacity: 2
    - x: 5
      y: 17
      landform: mountain
      collision: false
      opacity: 2
    - x: 5
      y: 18
      landform: water
      collision: true
      opacity: 0
    - x: 5
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 5
      y: 20
      landform: mountain
      collision: false
      opacity: 2
    - x: 5
      y: 21
      landform: desert
      collision: false
      opacity: 0
    - x: 5
      y: 22
      landform: water
      collision: true
      opacity: 0
    - x: 5
      y: 23
      landform: desert
      collision: false
      opacity: 0
    - x: 5
      y: 24
      landform: desert
      collision: false
      opacity: 0
    - x: 5
      y: 25
      landform: water
      collision: true
      opacity: 0
    - x: 5
      y: 26
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 3
      landform: forest
      collision: false
      opacity: 1
    - x: 6
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 6
      y: 5
      landform: plain
      collision: false
      opacity: 0
    - x: 6
      y: 6
      landform: forest
      collision: false
      opacity: 1
    - x: 6
      y: 7
      landform: forest
      collision: false
      opacity: 1
    - x: 6
      y: 8
      landform: forest
      collision: false
      opacity: 1
    - x: 6
      y: 9
      landform: forest
      collision: false
      opacity: 1
    - x: 6
      y: 10
      landform: forest
      collision: false
      opacity: 1
    - x: 6
      y: 11
      landform: forest
      collision: false
      opacity: 1
    - x: 6
      y: 12
      landform: plain
      collision: false
      opacity: 0
    - x: 6
      y: 13
      landform: desert
      collision: false
      opacity: 0
    - x: 6
      y: 14
      landform: mountain
      collision: false
      opacity: 2
    - x: 6
      y: 15
      landform: mountain
      collision: false
      opacity: 2
    - x: 6
      y: 16
      landform: desert
      collision: false
      opacity: 0
    - x: 6
      y: 17
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 18
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 20
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 21
      landform: mountain
      collision: false
      opacity: 2
    - x: 6
      y: 22
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 23
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 24
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 25
      landform: water
      collision: true
      opacity: 0
    - x: 6
      y: 26
      landform: water
      collision: true
      opacity: 0
    - x: 7
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 7
      y: 2
      landform: desert
      collision: false
      opacity: 0
    - x: 7
      y: 3
      landform: forest
      collision: false
      opacity: 1
    - x: 7
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 7
      y: 5
      landform: plain
      collision: false
      opacity: 0
    - x: 7
      y: 6
      landform: forest
      collision: false
      opacity: 1
    - x: 7
      y: 7
      landform: forest
      collision: false
      opacity: 1
    - x: 7
      y: 8
      landform: forest
      collision: false
      opacity: 1
    - x: 7
      y: 9
      landform: forest
      collision: false
      opacity: 1
    - x: 7
      y: 10
      landform: forest
      collision: false
      opacity: 1
    - x: 7
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 7
      y: 12
      landform: town
      collision: false
      opacity: 0
    - x: 7
      y: 13
      landform: mountain
      collision: false
      opacity: 2
    - x: 7
      y: 14
      landform: mountain
      collision: false
      opacity: 2
    - x: 7
      y: 15
      landform: mountain
      collision: false
      opacity: 2
    - x: 7
      y: 16
      landform: desert
      collision: false
      opacity: 0
    - x: 7
      y: 17
      landform: mountain
      collision: false
      opacity: 2
    - x: 7
      y: 18
      landform: mountain
      collision: false
      opacity: 2
    - x: 7
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 7
      y: 20
      landform: water
      collision: true
      opacity: 0
    - x: 7
      y: 21
      landform: water
      collision: true
      opacity: 0
    - x: 7
      y: 22
      landform: water
      collision: true
      opacity: 0
    - x: 7
      y: 23
      landform: forest
      collision: false
      opacity: 1
    - x: 7
      y: 24
      landform: forest
      collision: false
      opacity: 1
    - x: 7
      y: 25
      landform: water
      collision: true
      opacity: 0
    - x: 7
      y: 26
      landform: water
      collision: true
      opacity: 0
    - x: 8
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 8
      y: 2
      landform: forest
      collision: false
      opacity: 1
    - x: 8
      y: 3
      landform: forest
      collision: false
      opacity: 1
    - x: 8
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 8
      y: 5
      landform: forest
      collision: false
      opacity: 1
    - x: 8
      y: 6
      landform: forest
      collision: false
      opacity: 1
    - x: 8
      y: 7
      landform: forest
      collision: false
      opacity: 1
    - x: 8
      y: 8
      landform: forest
      collision: false
      opacity: 1
    - x: 8
      y: 9
      landform: forest
      collision: false
      opacity: 1
    - x: 8
      y: 10
      landform: forest
      collision: false
      opacity: 1
    - x: 8
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 8
      y: 12
      landform: mountain
      collision: false
      opacity: 2
    - x: 8
      y: 13
      landform: mountain
      collision: false
      opacity: 2
    - x: 8
      y: 14
      landform: mountain
      collision: false
      opacity: 2
    - x: 8
      y: 15
      landform: mountain
      collision: false
      opacity: 2
    - x: 8
      y: 16
      landform: desert
      collision: false
      opacity: 0
    - x: 8
      y: 17
      landform: mountain
      collision: false
      opacity: 2
    - x: 8
      y: 18
      landform: mountain
      collision: false
      opacity: 2
    - x: 8
      y: 19
      landform: mountain
      collision: false
      opacity: 2
    - x: 8
      y: 20
      landform: water
      collision: true
      opacity: 0
    - x: 8
      y: 21
      landform: town
      collision: false
      opacity: 0
    - x: 8
      y: 22
      landform: forest
      collision: false
      opacity: 1
    - x: 8
      y: 23
      landform: forest
      collision: false
      opacity: 1
    - x: 8
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 8
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 8
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 9
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 9
      y: 2
      landform: forest
      collision: false
      opacity: 1
    - x: 9
      y: 3
      landform: forest
      collision: false
      opacity: 1
    - x: 9
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 9
      y: 5
      landform: forest
      collision: false
      opacity: 1
    - x: 9
      y: 6
      landform: forest
      collision: false
      opacity: 1
    - x: 9
      y: 7
      landform: forest
      collision: false
      opacity: 1
    - x: 9
      y: 8
      landform: forest
      collision: false
      opacity: 1
    - x: 9
      y: 9
      landform: forest
      collision: false
      opacity: 1
    - x: 9
      y: 10
      landform: mountain
      collision: false
      opacity: 2
    - x: 9
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 9
      y: 12
      landform: mountain
      collision: false
      opacity: 2
    - x: 9
      y: 13
      landform: mountain
      collision: false
      opacity: 2
    - x: 9
      y: 14
      landform: forest
      collision: false
      opacity: 1
    - x: 9
      y: 15
      landform: forest
      collision: false
      opacity: 1
    - x: 9
      y: 16
      landform: plain
      collision: false
      opacity: 0
    - x: 9
      y: 17
      landform: mountain
      collision: false
      opacity: 2
    - x: 9
      y: 18
      landform: mountain
      collision: false
      opacity: 2
    - x: 9
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 9
      y: 20
      landform: water
      collision: true
      opacity: 0
    - x: 9
      y: 21
      landform: water
      collision: true
      opacity: 0
    - x: 9
      y: 22
      landform: forest
      collision: false
      opacity: 1
    - x: 9
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 9
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 9
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 9
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 10
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 10
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 10
      y: 3
      landform: plain
      collision: false
      opacity: 0
    - x: 10
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 10
      y: 5
      landform: forest
      collision: false
      opacity: 1
    - x: 10
      y: 6
      landform: forest
      collision: false
      opacity: 1
    - x: 10
      y: 7
      landform: forest
      collision: false
      opacity: 1
    - x: 10
      y: 8
      landform: forest
      collision: false
      opacity: 1
    - x: 10
      y: 9
      landform: mountain
      collision: false
      opacity: 2
    - x: 10
      y: 10
      landform: mountain
      collision: false
      opacity: 2
    - x: 10
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 10
      y: 12
      landform: mountain
      collision: false
      opacity: 2
    - x: 10
      y: 13
      landform: mountain
      collision: false
      opacity: 2
    - x: 10
      y: 14
      landform: forest
      collision: false
      opacity: 1
    - x: 10
      y: 15
      landform: forest
      collision: false
      opacity: 1
    - x: 10
      y: 16
      landform: plain
      collision: false
      opacity: 0
    - x: 10
      y: 17
      landform: forest
      collision: false
      opacity: 1
    - x: 10
      y: 18
      landform: water
      collision: true
      opacity: 0
    - x: 10
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 10
      y: 20
      landform: water
      collision: true
      opacity: 0
    - x: 10
      y: 21
      landform: water
      collision: true
      opacity: 0
    - x: 10
      y: 22
      landform: forest
      collision: false
      opacity: 1
    - x: 10
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 10
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 10
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 10
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 11
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 11
      y: 2
      landform: plain
      collision: false
      opacity: 0
    - x: 11
      y: 3
      landform: plain
      collision: false
      opacity: 0
    - x: 11
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 11
      y: 5
      landform: plain
      collision: false
      opacity: 0
    - x: 11
      y: 6
      landform: forest
      collision: false
      opacity: 1
    - x: 11
      y: 7
      landform: forest
      collision: false
      opacity: 1
    - x: 11
      y: 8
      landform: forest
      collision: false
      opacity: 1
    - x: 11
      y: 9
      landform: mountain
      collision: false
      opacity: 2
    - x: 11
      y: 10
      landform: mountain
      collision: false
      opacity: 2
    - x: 11
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 11
      y: 12
      landform: mountain
      collision: false
      opacity: 2
    - x: 11
      y: 13
      landform: mountain
      collision: false
      opacity: 2
    - x: 11
      y: 14
      landform: forest
      collision: false
      opacity: 1
    - x: 11
      y: 15
      landform: plain
      collision: false
      opacity: 0
    - x: 11
      y: 16
      landform: plain
      collision: false
      opacity: 0
    - x: 11
      y: 17
      landform: forest
      collision: false
      opacity: 1
    - x: 11
      y: 18
      landform: forest
      collision: false
      opacity: 1
    - x: 11
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 11
      y: 20
      landform: water
      collision: true
      opacity: 0
    - x: 11
      y: 21
      landform: water
      collision: true
      opacity: 0
    - x: 11
      y: 22
      landform: forest
      collision: false
      opacity: 1
    - x: 11
      y: 23
      landform: forest
      collision: false
      opacity: 1
    - x: 11
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 11
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 11
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 12
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 12
      y: 2
      landform: plain
      collision: false
      opacity: 0
    - x: 12
      y: 3
      landform: town
      collision: false
      opacity: 0
    - x: 12
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 12
      y: 5
      landform: plain
      collision: false
      opacity: 0
    - x: 12
      y: 6
      landform: plain
      collision: false
      opacity: 0
    - x: 12
      y: 7
      landform: forest
      collision: false
      opacity: 1
    - x: 12
      y: 8
      landform: water
      collision: true
      opacity: 0
    - x: 12
      y: 9
      landform: water
      collision: true
      opacity: 0
    - x: 12
      y: 10
      landform: water
      collision: true
      opacity: 0
    - x: 12
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 12
      y: 12
      landform: mountain
      collision: false
      opacity: 2
    - x: 12
      y: 13
      landform: forest
      collision: false
      opacity: 1
    - x: 12
      y: 14
      landform: forest
      collision: false
      opacity: 1
    - x: 12
      y: 15
      landform: plain
      collision: false
      opacity: 0
    - x: 12
      y: 16
      landform: plain
      collision: false
      opacity: 0
    - x: 12
      y: 17
      landform: forest
      collision: false
      opacity: 1
    - x: 12
      y: 18
      landform: forest
      collision: false
      opacity: 1
    - x: 12
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 12
      y: 20
      landform: water
      collision: true
      opacity: 0
    - x: 12
      y: 21
      landform: water
      collision: true
      opacity: 0
    - x: 12
      y: 22
      landform: water
      collision: true
      opacity: 0
    - x: 12
      y: 23
      landform: forest
      collision: false
      opacity: 1
    - x: 12
      y: 24
      landform: forest
      collision: false
      opacity: 1
    - x: 12
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 12
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 13
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 13
      y: 2
      landform: plain
      collision: false
      opacity: 0
    - x: 13
      y: 3
      landform: plain
      collision: false
      opacity: 0
    - x: 13
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 13
      y: 5
      landform: plain
      collision: false
      opacity: 0
    - x: 13
      y: 6
      landform: plain
      collision: false
      opacity: 0
    - x: 13
      y: 7
      landform: water
      collision: true
      opacity: 0
    - x: 13
      y: 8
      landform: water
      collision: true
      opacity: 0
    - x: 13
      y: 9
      landform: water
      collision: true
      opacity: 0
    - x: 13
      y: 10
      landform: water
      collision: true
      opacity: 0
    - x: 13
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 13
      y: 12
      landform: desert
      collision: false
      opacity: 0
    - x: 13
      y: 13
      landform: forest
      collision: false
      opacity: 1
    - x: 13
      y: 14
      landform: plain
      collision: false
      opacity: 0
    - x: 13
      y: 15
      landform: plain
      collision: false
      opacity: 0
    - x: 13
      y: 16
      landform: plain
      collision: false
      opacity: 0
    - x: 13
      y: 17
      landform: water
      collision: true
      opacity: 0
    - x: 13
      y: 18
      landform: forest
      collision: false
      opacity: 1
    - x: 13
      y: 19
      landform: forest
      collision: false
      opacity: 1
    - x: 13
      y: 20
      landform: forest
      collision: false
      opacity: 1
    - x: 13
      y: 21
      landform: forest
      collision: false
      opacity: 1
    - x: 13
      y: 22
      landform: forest
      collision: false
      opacity: 1
    - x: 13
      y: 23
      landform: forest
      collision: false
      opacity: 1
    - x: 13
      y: 24
      landform: forest
      collision: false
      opacity: 1
    - x: 13
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 13
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 14
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 14
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 14
      y: 3
      landform: plain
      collision: false
      opacity: 0
    - x: 14
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 14
      y: 5
      landform: forest
      collision: false
      opacity: 1
    - x: 14
      y: 6
      landform: plain
      collision: false
      opacity: 0
    - x: 14
      y: 7
      landform: desert
      collision: false
      opacity: 0
    - x: 14
      y: 8
      landform: water
      collision: true
      opacity: 0
    - x: 14
      y: 9
      landform: water
      collision: true
      opacity: 0
    - x: 14
      y: 10
      landform: mountain
      collision: false
      opacity: 2
    - x: 14
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 14
      y: 12
      landform: forest
      collision: false
      opacity: 1
    - x: 14
      y: 13
      landform: forest
      collision: false
      opacity: 1
    - x: 14
      y: 14
      landform: plain
      collision: false
      opacity: 0
    - x: 14
      y: 15
      landform: plain
      collision: false
      opacity: 0
    - x: 14
      y: 16
      landform: plain
      collision: false
      opacity: 0
    - x: 14
      y: 17
      landform: water
      collision: true
      opacity: 0
    - x: 14
      y: 18
      landform: water
      collision: true
      opacity: 0
    - x: 14
      y: 19
      landform: forest
      collision: false
      opacity: 1
    - x: 14
      y: 20
      landform: forest
      collision: false
      opacity: 1
    - x: 14
      y: 21
      landform: forest
      collision: false
      opacity: 1
    - x: 14
      y: 22
      landform: forest
      collision: false
      opacity: 1
    - x: 14
      y: 23
      landform: water
      collision: true
      opacity: 0
    - x: 14
      y: 24
      landform: water
      collision: true
      opacity: 0
    - x: 14
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 14
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 15
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 15
      y: 2
      landform: desert
      collision: false
      opacity: 0
    - x: 15
      y: 3
      landform: plain
      collision: false
      opacity: 0
    - x: 15
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 15
      y: 5
      landform: plain
      collision: false
      opacity: 0
    - x: 15
      y: 6
      landform: plain
      collision: false
      opacity: 0
    - x: 15
      y: 7
      landform: forest
      collision: false
      opacity: 1
    - x: 15
      y: 8
      landform: forest
      collision: false
      opacity: 1
    - x: 15
      y: 9
      landform: forest
      collision: false
      opacity: 1
    - x: 15
      y: 10
      landform: forest
      collision: false
      opacity: 1
    - x: 15
      y: 11
      landform: forest
      collision: false
      opacity: 1
    - x: 15
      y: 12
      landform: desert
      collision: false
      opacity: 0
    - x: 15
      y: 13
      landform: desert
      collision: false
      opacity: 0
    - x: 15
      y: 14
      landform: plain
      collision: false
      opacity: 0
    - x: 15
      y: 15
      landform: plain
      collision: false
      opacity: 0
    - x: 15
      y: 16
      landform: water
      collision: true
      opacity: 0
    - x: 15
      y: 17
      landform: water
      collision: true
      opacity: 0
    - x: 15
      y: 18
      landform: water
      collision: true
      opacity: 0
    - x: 15
      y: 19
      landform: forest
      collision: false
      opacity: 1
    - x: 15
      y: 20
      landform: forest
      collision: false
      opacity: 1
    - x: 15
      y: 21
      landform: plain
      collision: false
      opacity: 0
    - x: 15
      y: 22
      landform: forest
      collision: false
      opacity: 1
    - x: 15
      y: 23
      landform: water
      collision: true
      opacity: 0
    - x: 15
      y: 24
      landform: water
      collision: true
      opacity: 0
    - x: 15
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 15
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 16
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 16
      y: 2
      landform: desert
      collision: false
      opacity: 0
    - x: 16
      y: 3
      landform: desert
      collision: false
      opacity: 0
    - x: 16
      y: 4
      landform: plain
      collision: false
      opacity: 0
    - x: 16
      y: 5
      landform: plain
      collision: false
      opacity: 0
    - x: 16
      y: 6
      landform: forest
      collision: false
      opacity: 1
    - x: 16
      y: 7
      landform: forest
      collision: false
      opacity: 1
    - x: 16
      y: 8
      landform: forest
      collision: false
      opacity: 1
    - x: 16
      y: 9
      landform: forest
      collision: false
      opacity: 1
    - x: 16
      y: 10
      landform: mountain
      collision: false
      opacity: 2
    - x: 16
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 16
      y: 12
      landform: desert
      collision: false
      opacity: 0
    - x: 16
      y: 13
      landform: desert
      collision: false
      opacity: 0
    - x: 16
      y: 14
      landform: town
      collision: false
      opacity: 0
    - x: 16
      y: 15
      landform: water
      collision: true
      opacity: 0
    - x: 16
      y: 16
      landform: water
      collision: true
      opacity: 0
    - x: 16
      y: 17
      landform: water
      collision: true
      opacity: 0
    - x: 16
      y: 18
      landform: water
      collision: true
      opacity: 0
    - x: 16
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 16
      y: 20
      landform: forest
      collision: false
      opacity: 1
    - x: 16
      y: 21
      landform: forest
      collision: false
      opacity: 1
    - x: 16
      y: 22
      landform: mountain
      collision: false
      opacity: 2
    - x: 16
      y: 23
      landform: mountain
      collision: false
      opacity: 2
    - x: 16
      y: 24
      landform: water
      collision: true
      opacity: 0
    - x: 16
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 16
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 17
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 2
      landform: desert
      collision: false
      opacity: 0
    - x: 17
      y: 3
      landform: desert
      collision: false
      opacity: 0
    - x: 17
      y: 4
      landform: desert
      collision: false
      opacity: 0
    - x: 17
      y: 5
      landform: plain
      collision: false
      opacity: 0
    - x: 17
      y: 6
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 7
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 8
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 9
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 10
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 11
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 12
      landform: desert
      collision: false
      opacity: 0
    - x: 17
      y: 13
      landform: desert
      collision: false
      opacity: 0
    - x: 17
      y: 14
      landform: desert
      collision: false
      opacity: 0
    - x: 17
      y: 15
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 16
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 17
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 18
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 19
      landform: water
      collision: true
      opacity: 0
    - x: 17
      y: 20
      landform: wall
      collision: true
      opacity: 10
    - x: 17
      y: 21
      landform: wall
      collision: true
      opacity: 10
    - x: 17
      y: 22
      landform: wall
      collision: true
      opacity: 10
    - x: 17
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 17
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 17
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 17
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 18
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 3
      landform: desert
      collision: false
      opacity: 0
    - x: 18
      y: 4
      landform: desert
      collision: false
      opacity: 0
    - x: 18
      y: 5
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 6
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 7
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 8
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 9
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 10
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 11
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 12
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 13
      landform: desert
      collision: false
      opacity: 0
    - x: 18
      y: 14
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 15
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 16
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 17
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 18
      landform: water
      collision: true
      opacity: 0
    - x: 18
      y: 19
      landform: wall
      collision: true
      opacity: 10
    - x: 18
      y: 20
      landform: wall
      collision: true
      opacity: 10
    - x: 18
      y: 21
      landform: wall
      collision: true
      opacity: 10
    - x: 18
      y: 22
      landform: wall
      collision: true
      opacity: 10
    - x: 18
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 18
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 18
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 18
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 19
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 3
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 4
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 5
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 6
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 7
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 8
      landform: mountain
      collision: false
      opacity: 2
    - x: 19
      y: 9
      landform: mountain
      collision: false
      opacity: 2
    - x: 19
      y: 10
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 11
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 12
      landform: desert
      collision: false
      opacity: 0
    - x: 19
      y: 13
      landform: desert
      collision: false
      opacity: 0
    - x: 19
      y: 14
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 15
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 16
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 17
      landform: water
      collision: true
      opacity: 0
    - x: 19
      y: 18
      landform: wall
      collision: true
      opacity: 10
    - x: 19
      y: 19
      landform: wall
      collision: true
      opacity: 10
    - x: 19
      y: 20
      landform: wall
      collision: true
      opacity: 10
    - x: 19
      y: 21
      landform: wall
      collision: true
      opacity: 10
    - x: 19
      y: 22
      landform: wall
      collision: true
      opacity: 10
    - x: 19
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 19
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 19
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 19
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 20
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 20
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 20
      y: 3
      landform: water
      collision: true
      opacity: 0
    - x: 20
      y: 4
      landform: water
      collision: true
      opacity: 0
    - x: 20
      y: 5
      landform: water
      collision: true
      opacity: 0
    - x: 20
      y: 6
      landform: water
      collision: true
      opacity: 0
    - x: 20
      y: 7
      landform: mountain
      collision: false
      opacity: 2
    - x: 20
      y: 8
      landform: mountain
      collision: false
      opacity: 2
    - x: 20
      y: 9
      landform: mountain
      collision: false
      opacity: 2
    - x: 20
      y: 10
      landform: mountain
      collision: false
      opacity: 2
    - x: 20
      y: 11
      landform: desert
      collision: false
      opacity: 0
    - x: 20
      y: 12
      landform: desert
      collision: false
      opacity: 0
    - x: 20
      y: 13
      landform: water
      collision: true
      opacity: 0
    - x: 20
      y: 14
      landform: water
      collision: true
      opacity: 0
    - x: 20
      y: 15
      landform: water
      collision: true
      opacity: 0
    - x: 20
      y: 16
      landform: water
      collision: true
      opacity: 0
    - x: 20
      y: 17
      landform: wall
      collision: true
      opacity: 10
    - x: 20
      y: 18
      landform: wall
      collision: true
      opacity: 10
    - x: 20
      y: 19
      landform: wall
      collision: true
      opacity: 10
    - x: 20
      y: 20
      landform: wall
      collision: true
      opacity: 10
    - x: 20
      y: 21
      landform: wall
      collision: true
      opacity: 10
    - x: 20
      y: 22
      landform: wall
      collision: true
      opacity: 10
    - x: 20
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 20
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 20
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 20
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 21
      y: 1
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 3
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 4
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 5
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 6
      landform: mountain
      collision: false
      opacity: 2
    - x: 21
      y: 7
      landform: mountain
      collision: false
      opacity: 2
    - x: 21
      y: 8
      landform: mountain
      collision: false
      opacity: 2
    - x: 21
      y: 9
      landform: mountain
      collision: false
      opacity: 2
    - x: 21
      y: 10
      landform: mountain
      collision: false
      opacity: 2
    - x: 21
      y: 11
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 12
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 13
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 14
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 15
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 16
      landform: water
      collision: true
      opacity: 0
    - x: 21
      y: 17
      landform: wall
      collision: true
      opacity: 10
    - x: 21
      y: 18
      landform: wall
      collision: true
      opacity: 10
    - x: 21
      y: 19
      landform: wall
      collision: true
      opacity: 10
    - x: 21
      y: 20
      landform: wall
      collision: true
      opacity: 10
    - x: 21
      y: 21
      landform: wall
      collision: true
      opacity: 10
    - x: 21
      y: 22
      landform: wall
      collision: true
      opacity: 10
    - x: 21
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 21
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 21
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 21
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 1
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 2
      landform: water
      collision: true
      opacity: 0
    - x: 22
      y: 3
      landform: water
      collision: true
      opacity: 0
    - x: 22
      y: 4
      landform: water
      collision: true
      opacity: 0
    - x: 22
      y: 5
      landform: water
      collision: true
      opacity: 0
    - x: 22
      y: 6
      landform: mountain
      collision: false
      opacity: 2
    - x: 22
      y: 7
      landform: mountain
      collision: false
      opacity: 2
    - x: 22
      y: 8
      landform: mountain
      collision: false
      opacity: 2
    - x: 22
      y: 9
      landform: water
      collision: true
      opacity: 0
    - x: 22
      y: 10
      landform: water
      collision: true
      opacity: 0
    - x: 22
      y: 11
      landform: water
      collision: true
      opacity: 0
    - x: 22
      y: 12
      landform: water
      collision: true
      opacity: 0
    - x: 22
      y: 13
      landform: plain
      collision: false
      opacity: 0
    - x: 22
      y: 14
      landform: plain
      collision: false
      opacity: 0
    - x: 22
      y: 15
      landform: plain
      collision: false
      opacity: 0
    - x: 22
      y: 16
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 17
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 18
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 19
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 20
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 21
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 22
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 22
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 1
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 2
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 3
      landform: water
      collision: true
      opacity: 0
    - x: 23
      y: 4
      landform: water
      collision: true
      opacity: 0
    - x: 23
      y: 5
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 6
      landform: desert
      collision: false
      opacity: 0
    - x: 23
      y: 7
      landform: desert
      collision: false
      opacity: 0
    - x: 23
      y: 8
      landform: desert
      collision: false
      opacity: 0
    - x: 23
      y: 9
      landform: water
      collision: true
      opacity: 0
    - x: 23
      y: 10
      landform: water
      collision: true
      opacity: 0
    - x: 23
      y: 11
      landform: desert
      collision: false
      opacity: 0
    - x: 23
      y: 12
      landform: desert
      collision: false
      opacity: 0
    - x: 23
      y: 13
      landform: desert
      collision: false
      opacity: 0
    - x: 23
      y: 14
      landform: water
      collision: true
      opacity: 0
    - x: 23
      y: 15
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 16
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 17
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 18
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 19
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 20
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 21
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 22
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 23
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 1
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 2
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 3
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 4
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 5
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 6
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 7
      landform: desert
      collision: false
      opacity: 0
    - x: 24
      y: 8
      landform: desert
      collision: false
      opacity: 0
    - x: 24
      y: 9
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 10
      landform: desert
      collision: false
      opacity: 0
    - x: 24
      y: 11
      landform: desert
      collision: false
      opacity: 0
    - x: 24
      y: 12
      landform: mountain
      collision: false
      opacity: 2
    - x: 24
      y: 13
      landform: mountain
      collision: false
      opacity: 2
    - x: 24
      y: 14
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 15
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 16
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 17
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 18
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 19
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 20
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 21
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 22
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 24
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 1
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 2
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 3
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 4
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 5
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 6
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 7
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 8
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 9
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 10
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 11
      landform: mountain
      collision: false
      opacity: 2
    - x: 25
      y: 12
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 13
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 14
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 15
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 16
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 17
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 18
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 19
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 20
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 21
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 22
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 25
      y: 26
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 1
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 2
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 3
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 4
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 5
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 6
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 7
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 8
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 9
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 10
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 11
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 12
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 13
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 14
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 15
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 16
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 17
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 18
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 19
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 20
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 21
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 22
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 23
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 24
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 25
      landform: wall
      collision: true
      opacity: 10
    - x: 26
      y: 26
      landform: wall
      collision: true
      opacity: 10
ROKUME
  end
end