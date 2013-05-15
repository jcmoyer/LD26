local data = {}

data.background = { 200, 200, 200 }

data.lines = {
  0, 444,
  100, 444,
  114, 452,
  128, 463,
  141, 478,
  157, 498,
  173, 512,
  183, 519,
  193, 525,
  201, 530,
  210, 535,
  222, 533,
  239, 535,
  253, 539,
  267, 543,
  283, 547,
  303, 555,
  315, 562,
  329, 567,
  344, 570,
  358, 574,
  368, 579,
  380, 580,
  389, 587,
  396, 593,
  401, 595,
  410, 596,
  421, 595,
  433, 604,
  449, 605,
  455, 603,
  461, 602,
  470, 604,
  475, 609,
  478, 614,
  491, 624,
  503, 626,
  515, 629,
  526, 630,
  536, 631,
  544, 636,
  552, 643,
  558, 648,
  566, 649,
  578, 649,
  595, 650,
  606, 652,
  617, 657,
  628, 658,
  640, 657,
  657, 659,
  667, 659,
  678, 660,
  708, 664,
  778, 667,
  791, 666,
  805, 664,
  848, 667,
  871, 673,
  893, 679,
  914, 683,
  934, 684,
  958, 684,
  986, 685,
  1016, 691,
  1031, 699,
  1044, 706,
  1059, 710,
  1077, 714,
  1092, 718,
  1106, 724,
  1118, 726,
  1131, 723,
  1144, 725,
  1157, 726,
  1177, 730,
  1195, 730,
  1216, 732,
  1233, 739,
  1243, 744,
  1254, 747,
  1287, 748,
  1315, 755,
  1345, 756,
  1363, 759,
  1393, 762,
  1415, 770,
  1443, 771,
  1464, 765,
  1498, 762,
  1542, 762,
  1571, 767,
  1599, 769,
  1625, 770,
  1646, 776,
  1694, 779,
  1724, 777,
  1751, 778,
  1774, 782,
  1788, 786,
  1805, 786,
  1823, 784,
  1830, 783,
  1860, 780,
  1882, 785,
  1899, 790,
  1944, 794,
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
  2262, 819,
  2277, 816,
  2289, 822,
  2301, 830,
  2318, 833,
  2337, 832,
  2362, 823,
  2390, 822,
  2407, 827,
  2430, 826,
  2468, 833,
  2489, 836,
  2508, 837,
  2527, 837,
  2544, 836,
  2565, 835,
  2597, 841,
  2621, 845,
  2649, 844,
  2673, 850,
  2700, 850,
  2800, 850
}

data.portals = {
  { x = 50  , destination = 'introworld' , dx = 2371 },
  { x = 2750, destination = 'introworld3', dx = 50 }
}
data.regions = {
  { name = 'r_noidea', x = 1286, w = 20 }
}

data.triggers = {}

function data.triggers.onEnter(context)
  if not context.getVar('introworld2.entered') then
    context.showMessage('where are you going?', 10)
    context.setVar('introworld2.entered', true)
  end
end

function data.triggers.onEnterRegion(context, r)
  if r.name == 'r_noidea' and not context.getVar('introworld2.noidea') then
    context.showMessage('i bet you have no idea what you\'re doing', 10)
    context.setVar('introworld2.noidea', true)
  end
end

return data