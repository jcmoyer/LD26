local data = {}

data.background = { 230, 230, 230 }

data.lines = {
  0, 443,
  53, 444,
  77, 451,
  89, 461,
  104, 471,
  114, 472,
  127, 476,
  135, 481,
  145, 488,
  151, 493,
  158, 502,
  167, 512,
  172, 522,
  184, 527,
  201, 530,
  210, 535,
  220, 534,
  236, 532,
  253, 539,
  266, 545,
  283, 547,
  303, 555,
  319, 567,
  329, 567,
  349, 567,
  358, 574,
  368, 579,
  380, 580,
  396, 593,
  401, 595,
  410, 596,
  421, 595,
  433, 604,
  453, 606,
  464, 602,
  470, 604,
  478, 614,
  491, 624,
  515, 629,
  536, 631,
  544, 636,
  566, 649,
  578, 649,
  595, 650,
  617, 657,
  640, 657,
  661, 663,
  678, 660,
  708, 664,
  778, 667,
  805, 664,
  848, 667,
  871, 673,
  893, 681,
  914, 683,
  934, 684,
  958, 684,
  986, 685,
  1016, 691,
  1044, 706,
  1077, 714,
  1107, 724,
  1131, 723,
  1144, 725,
  1157, 726,
  1177, 730,
  1195, 730,
  1216, 732,
  1233, 739,
  1254, 747,
  1287, 748,
  1315, 755,
  1345, 756,
  1363, 759,
  1395, 759,
  1415, 770,
  1443, 771,
  1464, 765,
  1498, 762,
  1542, 762,
  1564, 772,
  1599, 769,
  1625, 770,
  1641, 778,
  1694, 779,
  1724, 777,
  1762, 776,
  1787, 789,
  1823, 784,
  1830, 783,
  1860, 780,
  1899, 790,
  1982, 795,
  2063, 789,
  2094, 792,
  2121, 804,
  2151, 815,
  2163, 819,
  2178, 817,
  2194, 815,
  2210, 817,
  2229, 821,
  2247, 824,
  2280, 820,
  2299, 829,
  2327, 827,
  2347, 828,
  2392, 821,
  2437, 835,
  2471, 834,
  2524, 841,
  2565, 835,
  2673, 850,
  2700, 850,
  2800, 850
}

data.portals = {
  { x = 50  , destination = 'data.introworld' , dx = 2371 },
  { x = 2750, destination = 'data.introworld3', dx = 50 }
}
data.regions = {
  { name = 'r_noidea', x = 1286, w = 20 }
}

data.triggers = {}

function data.triggers.onEnter(context)
  context.showMessage('where are you going?', 10)
end

local r_noidea_triggered = false
function data.triggers.onEnterRegion(context, r)
  if (r.name == 'r_noidea' and not r_noidea_triggered) then
    context.showMessage('i bet you have no idea what you\'re doing', 10)
    r_noidea_triggered = true
  end
end

return data
