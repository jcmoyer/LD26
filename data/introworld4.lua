local data = {}

data.background = { 200, 200, 200 }

data.lines = {
  -100, 300,
  0, 300,
  47, 304,
  94, 312,
  149, 327,
  205, 345,
  242, 366,
  279, 376,
  320, 390,
  359, 408,
  403, 429,
  449, 452,
  493, 490,
  533, 526,
  584, 572,
  625, 616,
  667, 646,
  709, 663,
  726, 669,
  743, 675,
  758, 679,
  774, 679,
  787, 679,
  814, 679,
  825, 679,
  836, 679,
  844, 679,
  856, 683,
  867, 687,
  883, 690,
  908, 697,
  942, 702,
  994, 707,
  1038, 733,
  1069, 760,
  1096, 784,
  1119, 807,
  1151, 840,
  1177, 882,
  1201, 905,
  1230, 927,
  1254, 941,
  1277, 952,
  1300, 957,
  1400, 957
}

data.portals = {
  { x = 800 , destination = 'data.introworld3', dx = 1250 },
  { x = 1350, destination = 'data.introworld5', dx = 100 }
}

data.triggers = {}
function data.triggers.onEnter(context)
  if not context.getVar('introworld4.entered') then
    context.showMessage('turn back while you still can', 10)
    context.setVar('introworld4.entered', true)
  end
  if context.getVar('puzzleworld1.solved') then
    context.addPortal('winroom', -50, 'data.treasureroom', 50, true)
  end
end

return data
