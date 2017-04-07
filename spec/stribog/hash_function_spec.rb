require 'spec_helper'

# TODO: REFACTOR
describe Stribog::CreateHash do
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
