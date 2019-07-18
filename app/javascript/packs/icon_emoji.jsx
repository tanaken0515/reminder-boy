import React from 'react'
import ReactDOM from 'react-dom'
import { Emoji } from 'emoji-mart'

class IconEmoji extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let icon;
    if(this.props.emojiValue) {
      if(this.props.isCustom) {
        icon = <figure className="image is-32x32"><img src={this.props.imageUrl} alt={this.props.emojiValue}></img></figure>;
      } else {
        icon = <Emoji emoji={{ id: this.props.emojiValue }} size={32}/>;
      }
    } else {
      icon = <div className='is-size-4'><i className="far fa-smile"></i></div>;
    }

    return <div>{icon}</div>
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const $iconEmojis = Array.prototype.slice.call(document.querySelectorAll('.icon-emoji'), 0);

  if ($iconEmojis.length > 0) {
    $iconEmojis.forEach(el => {
      const isCustom = (el.getAttribute('data-is-custom') === 'true');

      ReactDOM.render(
        <IconEmoji
          emojiValue={el.getAttribute('data-emoji-value')}
          isCustom={isCustom}
          imageUrl={el.getAttribute('data-image-url')}
        />,
        el
      );
    });
  }
});
