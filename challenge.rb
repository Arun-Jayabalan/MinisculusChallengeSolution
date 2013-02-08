##### MINISCULUS CHALLENGE - SOLUTION #######
#### Using one of the http client  like fiddler, Dev http client or CURL get the responses  ####

$characterSet=["0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
               "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
               "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
               "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
               "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
               ".", ",", "?", "!", "'", "\"", " "]

def encoder_mark_i(first_wheel,messageToBeEncoded)
  messageToBeEncoded.split(//).map{|messageChar|$characterSet[($characterSet.index(messageChar)+first_wheel) % $characterSet.length]}.join
end

puts encoder_mark_i(6,"Strong NE Winds!")

def encoder_mark_ii(first_wheel,second_wheel,messageToBeEncoded)
  messageToBeEncoded.split(//).map{|messageChar|$characterSet[(($characterSet.index(messageChar)+first_wheel) - (2 * second_wheel)) % $characterSet.length]}.join
end

puts encoder_mark_ii(9,3,"The Desert Fox will move 30 tanks to Calais at dawn")

def encoder_mark_iv(first_wheel,second_wheel,messageToBeEncoded)
  encodedChars = messageToBeEncoded.split(//)
  encodedMessage =""
  for i in 0...encodedChars.length
    i==0? third_Wheel=0 : third_Wheel=$characterSet.index(encodedChars[i-1])
    encodedMessage << encoder_mark_i(2 * third_Wheel , $characterSet[(($characterSet.index(encodedChars[i])+first_wheel) - (2 * second_wheel)) % $characterSet.length])
  end
  encodedMessage
end

puts encoder_mark_iv(4,7,"The white cliffs of Alghero are visible at night")

def decoder_for_mark_iv(first_wheel,second_wheel,messageToBeDecoded)
  encodedChars = messageToBeDecoded.split(//)
  third_wheel_positions=[0]
  decodedChars=[]

  for i in 0...encodedChars.length
    decodedChars.push << encoder_mark_ii(-first_wheel,-second_wheel,$characterSet[($characterSet.index(encodedChars[i])+ (third_wheel_positions[i] * -2) ) % $characterSet.length])
    third_wheel_positions[i+1]=$characterSet.index(decodedChars[i])
  end

  decodedChars.join
end

puts decoder_for_mark_iv(7,2,"WZyDsL3u'0TfxP06RtSSF 'DbzhdyFIAu2 zF f5KE\"SOQTNA8A\"NCKPOKG5D9GSQE'M86IGFMKE6'K4pEVPK!bv83I")

#print mark_IV_encoder(7,2,"The rockets will strike at coordinates 49.977984 7.9257857 422979.83 5536735.81 on Oct. 7th")


def wheel_positions_and_message_decoder_for_mark_iv(encoded_message,clueWord)
  wheelPositions =Array.new
  for firstWheel in 0...9
    for secondWheel in 0...9
      tmpDecodedMessage=decoder_for_mark_iv(firstWheel,secondWheel,encoded_message)
      if (tmpDecodedMessage.include? clueWord)
        wheelPositions.push [firstWheel,secondWheel]
        decodedMessage = tmpDecodedMessage
      end
    end
  end
  return [wheelPositions,decodedMessage]
end

print wheel_positions_and_message_decoder_for_mark_iv("QT4e8MJYVhkls.27BL9,.MSqYSi'IUpAJKWg9Ul9p4o8oUoGy'ITd4d0AJVsLQp4kKJB2rz4dxfahwUa\"Wa.MS!k4hs2yY3k8ymnla.MOTxJ6wBM7sC0srXmyAAMl9t\"Wk4hs2yYTtH0vwUZp4a\"WhB2u,o6.!8Zt\"Wf,,eh5tk8WXv9UoM99w2Vr4!.xqA,5MSpWl9p4kJ2oUg'6evkEiQhC'd5d4k0qA'24nEqhtAQmy37il9p4o8vdoVr!xWSkEDn?,iZpw24kF\"fhGJZMI8nkI","BUNKER")
print "\n"
#print wheel_positions_and_message_decoder_for_mark_iv("QT4e8MJYVhkls.27BL9,.MSqYSi'IUpAJKWg9Ul9p4o8oUoGy'ITd4d0AJVsLQp4kKJB2rz4dxfahwUa\"Wa.MS!k4hs2yY3k8ymnla.MOTxJ6wBM7sC0srXmyAAMl9t\"Wk4hs2yYTtH0vwUZp4a\"WhB2u,o6.!8Zt\"Wf,,eh5tk8WXv9UoM99w2Vr4!.xqA,5MSpWl9p4kJ2oUg'6evkEiQhC'd5d4k0qA'24nEqhtAQmy37il9p4o8vdoVr!xWSkEDn?,iZpw24kF\"fhGJZMI8nkI","FURLIN")
