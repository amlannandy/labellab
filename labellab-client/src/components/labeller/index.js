import React, { Component } from "react";
import LabelingApp from "./LabelingApp.js";
import { connect } from "react-redux";
import { Loader, Dimmer } from "semantic-ui-react";
import DocumentMeta from "react-document-meta";
import { fetchLabels, updateLabels } from "../../actions/label";

class LabelingLoader extends Component {
  constructor(props) {
    super(props);
    this.state = {
      project: null,
      image: null,
      isLoaded: false,
      error: null
    };
  }
  componentDidMount() {
    this.props.fetchLabels(this.props.location.pathname.substring(10, 34));
  }
  pushUpdate(labelData) {
    let image_id = this.props.location.pathname.substring(35);
    this.props.updateLabels(image_id,labelData);
  }
  markcomplete() {}
  render() {
    const props = {
      onLabelChange: this.pushUpdate.bind(this)
    };

    const title = "dfahsgdu";
    return (
      <DocumentMeta title={title}>
        {this.props.actions.isfetching && this.props.actions.isupdating ? (
          <Dimmer
            active={
              this.props.actions.isfetching && this.props.actions.isupdating
            }
          >
            <Loader indeterminate>Have some patience :)</Loader>
          </Dimmer>
        ) : (
          <LabelingApp
            labels={this.props.lab}
            // reference={{ referenceLink, referenceText }}
            labelData={{}}
            imageUrl="http://localhost:4000/static/project/5d0f8870643b413a6707c776.png"
            // fetch={this.fetch.bind(this)}
            demo={false}
            {...props}
          />
        )}
      </DocumentMeta>
    );
  }
}

const mapStateToProps = state => {
  return {
    lab: state.labels.labels,
    actions: state.labels.labelActions
  };
};

const mapDispatchToProps = dispatch => {
  return {
    fetchLabels: project_id => {
      return dispatch(fetchLabels(project_id));
    },
    updateLabels: (image_id,labelData) => {
      return dispatch(updateLabels(image_id,labelData));
    }
  };
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(LabelingLoader);
