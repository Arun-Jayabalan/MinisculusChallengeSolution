##### MINISCULUS CHALLENGE - SOLUTION #######
require 'rest-client'
require 'json'

$characterSet=["0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
               "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
               "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
               "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
               "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
               ".", ",", "?", "!", "'", "\"", " "]

def submit_answer(answer,reference_url)

  minisUri = "http://minisculuschallenge.com/"
  reference_code = reference_url.split("/")
  reference_url = minisUri << reference_code[2][0..-6]
  body = {
      answer:answer
  }.to_json

  response = RestClient.put reference_url, body, {:content_type => :json}
  data=JSON.parse(response.body)

  if data["code"] != nil
    puts "Code :" << data["code"]
    puts ""
    return data["code"]
  else
    puts  "Question: " << data["question"]
    puts "Reference Url: " << data["reference-url"]
    puts ""
    return [data["question"],data["reference-url"]]
  end

end

def encoder_mark_i(first_wheel,messageToBeEncoded)
  messageToBeEncoded.split(//).map{|messageChar|$characterSet[($characterSet.index(messageChar)+first_wheel) % $characterSet.length]}.join
end


def encoder_mark_ii(first_wheel,second_wheel,messageToBeEncoded)
  messageToBeEncoded.split(//).map{|messageChar|$characterSet[(($characterSet.index(messageChar)+first_wheel) - (2 * second_wheel)) % $characterSet.length]}.join
end

#puts encoder_mark_ii(9,3,"The Desert Fox will move 30 tanks to Calais at dawn")

def encoder_mark_iv(first_wheel,second_wheel,messageToBeEncoded)
  encodedChars = messageToBeEncoded.split(//)
  encodedMessage =""
  for i in 0...encodedChars.length
    i==0? third_Wheel=0 : third_Wheel=$characterSet.index(encodedChars[i-1])
    encodedMessage << encoder_mark_i(2 * third_Wheel , $characterSet[(($characterSet.index(encodedChars[i])+first_wheel) - (2 * second_wheel)) % $characterSet.length])
  end
  encodedMessage
end


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

nextQuestion , refUrl = submit_answer(encoder_mark_i(6,"Strong NE Winds!"),"/question/14f7ca5f6ff1a5afb9032aa5e533ad95.html")
nextQuestion , refUrl = submit_answer(encoder_mark_ii(9,3,nextQuestion),refUrl)
nextQuestion , refUrl = submit_answer(encoder_mark_iv(4,7,nextQuestion),refUrl)
code = submit_answer(decoder_for_mark_iv(7,2,nextQuestion),refUrl)
puts "****** Answer : [Wheel positions] <Answer> ************"
print  wheel_positions_and_message_decoder_for_mark_iv(code,"BUNKER")
puts ""
puts "********************************************************"
