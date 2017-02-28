require 'spec_helper'

# TODO: REFACTOR
describe Stribog::CreateHash do
  # context '256 bit hash, with 504 bit message' do
  #   context 'correct message and correct hash' do
  #     message = '323130393837363534333231303938373635343332313039383736353433323130393837363534333231303938373635343332313039383736353433323130'
  #     q = Stribog::CreateHash.new(message)
  #     it 'should has correct hash' do
  #       expect(q.(256).hex).to eq('557be5e584fd52a449b16b0251d05d27f94ab76cbaa6da890b59d8ef1e159d')
  #     end
  #   end
  #
  #   context 'incorrect message and incorrect hash' do
  #     message = '323130393837363534333231303938373635343332313039383736353433323130393837363534333231303938373635343332313039383736353433323131'
  #     q = Stribog::CreateHash.new(message)
  #     it 'should has correct hash' do
  #       expect(q.(256).hex).not_to eq('557be5e584fd52a449b16b0251d05d27f94ab76cbaa6da890b59d8ef1e159d')
  #     end
  #   end
  # end
  #
  # context '256 bit hash, with 576 bit message' do
  #   context 'correct message and correct hash' do
  #     message = 'fbe2e5f0eee3c820fbeafaebef20fffbf0e1e0f0f520e0ed20e8ece0ebe5f0f2f120fff0eeec20f120faf2fee5e2202ce8f6f3ede220e8e6eee1e8f0f2d1202ce8f0f2e5e220e5d1'
  #     q = Stribog::CreateHash.new(message)
  #     it 'should has correct hash' do
  #       expect(q.(256).hex).to eq('508f7e553c06501d749a66fc28c6cac0b005746d97537fa85d9e40904efed29d')
  #     end
  #   end
  #
  #   context 'incorrect message and incorrect hash' do
  #     message = 'fbe2e5f0eee3c820fbeafaebef20fffbf0e1e0f0f520e0ed20e8ece0ebe5f0f2f120fff0eeec20f120faf2fee5e2202ce8f6f3ede220e8e6eee1e8f0f2d1202ce8f0f2e5e220e5d2'
  #     q = Stribog::CreateHash.new(message)
  #     it 'should has correct hash' do
  #       expect(q.(256).hex).not_to eq('508f7e553c06501d749a66fc28c6cac0b005746d97537fa85d9e40904efed29d')
  #     end
  #   end
  # end
  #
  # context '512 bit hash, with 504 bit message' do
  #   context 'correct message and correct hash' do
  #     message = '323130393837363534333231303938373635343332313039383736353433323130393837363534333231303938373635343332313039383736353433323130'
  #     q = Stribog::CreateHash.new(message)
  #     it 'should has correct hash' do
  #       expect(q.(512).hex).to eq('486f64c1917879417fef082b3381a4e211c324f074654c38823a7b76f830ad00fa1fbae42b1285c0352f227524bc9ab16254288dd6863dccd5b9f54a1ad0541b')
  #     end
  #   end
  #
  #   context 'incorrect message and incorrect hash' do
  #     message = '323130393837363534333231303938373635343332313039383736353433323130393837363534333231303938373635343332313039383736353433323131'
  #     q = Stribog::CreateHash.new(message)
  #     it 'should has correct hash' do
  #       expect(q.(512).hex).not_to eq('486f64c1917879417fef082b3381a4e211c324f074654c38823a7b76f830ad00fa1fbae42b1285c0352f227524bc9ab16254288dd6863dccd5b9f54a1ad0541b')
  #     end
  #   end
  # end
  #
  # context '512 bit hash, with 576 bit message' do
  #   context 'correct message and correct hash' do
  #     message = 'fbe2e5f0eee3c820fbeafaebef20fffbf0e1e0f0f520e0ed20e8ece0ebe5f0f2f120fff0eeec20f120faf2fee5e2202ce8f6f3ede220e8e6eee1e8f0f2d1202ce8f0f2e5e220e5d1'
  #     q = Stribog::CreateHash.new(message)
  #     it 'should has correct hash' do
  #       expect(q.(512).hex).to eq('28fbc9bada033b1460642bdcddb90c3fb3e56c497ccd0f62b8a2ad4935e85f037613966de4ee00531ae60f3b5a47f8dae06915d5f2f194996fcabf2622e6881e')
  #     end
  #   end
  #
  #   context 'incorrect message and incorrect hash' do
  #     message = 'fbe2e5f0eee3c820fbeafaebef20fffbf0e1e0f0f520e0ed20e8ece0ebe5f0f2f120fff0eeec20f120faf2fee5e2202ce8f6f3ede220e8e6eee1e8f0f2d1202ce8f0f2e5e220e5d2'
  #     q = Stribog::CreateHash.new(message)
  #     it 'should has correct hash' do
  #       expect(q.(512).hex).not_to eq('28fbc9bada033b1460642bdcddb90c3fb3e56c497ccd0f62b8a2ad4935e85f037613966de4ee00531ae60f3b5a47f8dae06915d5f2f194996fcabf2622e6881e')
  #     end
  #   end
  # end

  # context '1000 bytes message' do
  #   message = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac augue metus. Integer et feugiat nisl, at dignissim nisi. Nullam id pharetra felis. Fusce in felis eu leo gravida imperdiet sed id velit. Nam dignissim porttitor massa, quis vestibulum magna malesuada vitae. Maecenas aliquam sit amet sem vitae varius. Pellentesque facilisis bibendum eros quis cursus. Cras dolor urna, facilisis porta eros quis, commodo fermentum risus. In hac habitasse platea dictumst. Ut eget sollicitudin lectus. Sed porta elit arcu, lobortis maximus libero aliquam at. Integer dignissim tincidunt eros sit amet dapibus. Nulla sit amet mattis elit, sit amet semper nunc. Fusce nisl tellus, mollis scelerisque condimentum id, convallis at felis. Ut dignissim tincidunt mattis. Nunc eget purus eu metus fringilla fringilla. Curabitur dapibus cursus enim, consequat porttitor sapien scelerisque sit amet. Curabitur tristique accumsan erat. Vivamus imperdiet nisl libero, ut vehicula nibh mollis in. Mauris viverra fusce.'
  #   q = Stribog::CreateHash.new(message)
  #
  #   it 'should has correct hash 256 bit' do
  #     expect(q.(256).hex).to eq('ecb9740fe86431761b774916ad420fee0beb422cf714640a8f962343c8b88476')
  #   end
  #
  #   it 'should has correct hash 512 bit' do
  #     expect(q.(512).hex).to eq('7d99e2c04f74519c793cbc5ca06239b2600c62ffe74ef275a13e895da83c4f396135e0b73a140f0246d0414dd2e2f3fbca30093e73106f74d3eeb9873af4dfe8')
  #   end
  # end

  context 'from string' do
    message = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac augue metus. Integer et feugiat nisl, at dignissim nisi. Nullam id pharetra felis. Fusce in felis eu leo gravida imperdiet sed id velit. Nam dignissim porttitor massa, quis vestibulum magna malesuada vitae. Maecenas aliquam sit amet sem vitae varius. Pellentesque facilisis bibendum eros quis cursus. Cras dolor urna, facilisis porta eros quis, commodo fermentum risus. In hac habitasse platea dictumst. Ut eget sollicitudin lectus. Sed porta elit arcu, lobortis maximus libero aliquam at. Integer dignissim tincidunt eros sit amet dapibus. Nulla sit amet mattis elit, sit amet semper nunc. Fusce nisl tellus, mollis scelerisque condimentum id, convallis at felis. Ut dignissim tincidunt mattis. Nunc eget purus eu metus fringilla fringilla. Curabitur dapibus cursus enim, consequat porttitor sapien scelerisque sit amet. Curabitur tristique accumsan erat. Vivamus imperdiet nisl libero, ut vehicula nibh mollis in. Mauris viverra fusce.'
    q = Stribog::CreateHash.new(message, :convert)

    it 'should has correct hash 256 bit' do
      expect(q.(256).dec).to eq(7146851722000598646893885926207107664174491480769238834418287159493243751027)
    end

    it 'should has correct hash 512 bit' do
      expect(q.(512).dec).to eq(7667256165366964128384803258770285854063150867032672647971338673364579783971286599384204043806276235839777454433027326929631323857983524142531506016786670)
    end
  end
end
