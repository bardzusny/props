import React from 'react';
import styles from './style.css';

export default class Pagination extends React.Component {
  static get propTypes() {
    return {
      hasNextPage: React.PropTypes.bool.isRequired,
      hasPreviousPage: React.PropTypes.bool.isRequired,
      onPrevPageClick: React.PropTypes.func.isRequired,
      onNextPageClick: React.PropTypes.func.isRequired,
      currentPage: React.PropTypes.number,
    };
  }

  render() {
    const prevButton = (
      <li>
        <a
          className="previous-page"
          href="previous-page"
          onClick={this.props.onPrevPageClick}
        >
            Previous
        </a>
      </li>
    );
    const nextButton = (
      <li>
        <a className="next-page" href="next-page" onClick={this.props.onNextPageClick}>Next</a>
      </li>
    );

    return (
      <nav className={styles.main}>
        <ul className="pagination">
          {this.props.hasPreviousPage ? prevButton : null}
          <li className="current-page">
            <span>{this.props.currentPage}</span>
          </li>
          {this.props.hasNextPage ? nextButton : null}
        </ul>
      </nav>
    );
  }
}
