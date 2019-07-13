import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import 'emoji-mart/css/emoji-mart.css'
import { Picker } from 'emoji-mart'

const CUSTOM_EMOJIS = [
  {
    name: 'Party Parrot',
    short_names: ['parrot'],
    keywords: ['party'],
    imageUrl: './images/parrot.gif'
  },
  {
    name: 'Octocat',
    short_names: ['octocat'],
    keywords: ['github'],
    imageUrl: 'https://github.githubassets.com/images/icons/emoji/octocat.png'
  },
  {
    name: 'Squirrel',
    short_names: ['shipit', 'squirrel'],
    keywords: ['github'],
    imageUrl: 'https://github.githubassets.com/images/icons/emoji/shipit.png'
  },
  {
    name: 'Test Flag',
    short_names: ['test'],
    keywords: ['test', 'flag'],
    spriteUrl: 'https://unpkg.com/emoji-datasource-twitter@4.0.4/img/twitter/sheets-256/64.png',
    sheet_x: 1,
    sheet_y: 1,
    size: 64,
    sheetColumns: 52,
    sheetRows: 52,
  },
]

class Example extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      native: true,
      set: 'native',
      emoji: 'point_up',
      title: 'Pick your emoji…',
      custom: CUSTOM_EMOJIS,
    }
  }

  render() {
    return <div>
      <div className="row">
        <Picker
          {...this.state}
          onSelect={console.log}
        />
      </div>
    </div>
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const $picker = document.querySelector('#picker')
  $picker.addEventListener('click', () => {
    const $pickerMenu = document.querySelector('#picker-menu')
    if ($pickerMenu.children.length > 0) {
      $pickerMenu.removeChild($pickerMenu.firstChild)
    }
    ReactDOM.render(<Example />, $pickerMenu)
  })
})
