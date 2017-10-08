field = [nil, nil, nil, nil, nil, nil, true, nil, nil, true, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
endpos = 2

  array = [[endpos + 3, endpos - 3]]
  case endpos % 6
    when 0
      array <<[endpos + 1, endpos + 2]
    when 1
      array <<[endpos + 1, endpos - 1]
    when 2
      array <<[endpos - 1, endpos - 2]
    else
      array = [[endpos + 3, endpos + 6],[endpos - 3, endpos - 6]]
  end
  for i in 0..array.length - 1
    puts i.to_s
    if(field[array[i][0]] && field[array[i][1]])
      puts "lel"
      return true

    end
  end
puts "not so lel"
  return false
