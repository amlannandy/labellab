import 'dart:async';

import 'package:labellab_mobile/data/repository.dart';
import 'package:labellab_mobile/model/team.dart';
import 'package:labellab_mobile/screen/project/team_details/team_details_state.dart';

class TeamDetailsBloc {
  String? _projectId;
  String? _teamId;
  List<String>? _roles;
  Team? _team;
  Repository _repository = Repository();

  TeamDetailsBloc(this._projectId, this._teamId) {
    _loadTeam();
  }

  void refresh() {
    _loadTeam();
  }

  void _loadTeam() {
    _repository.getTeamDetails(this._projectId!, this._teamId!).then((team) {
      this._team = team;
      _repository.getMemberRoles(this._projectId!).then((roles) {
        this._roles = roles;
        this._setState(TeamDetailsState.success(
          this._projectId,
          this._teamId,
          team,
        ));
      });
    }).catchError((err) {
      print(err);
      this._setState(TeamDetailsState.error(err.toString()));
    });
  }

  // Team stream
  StreamController<TeamDetailsState> _stateController =
      StreamController<TeamDetailsState>();

  Stream<TeamDetailsState> get state => _stateController.stream;

  void dispose() {
    _stateController.close();
  }

  _setState(TeamDetailsState state) {
    if (!_stateController.isClosed) _stateController.add(state);
  }

  bool isAdmin() {
    return this._roles!.contains('admin');
  }

  void addTeamMember(String memberEmail) {
    _repository
        .addTeamMember(this._projectId!, this._teamId!, memberEmail)
        .then((res) {
      refresh();
    });
  }

  void removeTeamMember(String memberEmail) {
    _repository
        .removeTeamMember(this._projectId!, this._teamId!, memberEmail)
        .then((res) {
      refresh();
    });
  }

  bool hasTeamAccess() {
    if (_team == null || _roles == null) return false;

    if (_roles!.contains('admin')) return true;

    return _roles!.contains(_team!.role);
  }

  void delete() {
    _repository.deleteTeam(this._projectId!, this._teamId!);
  }

  String get projectId => this.projectId;

  String get teamId => this.teamId;

  Team get team => this._team!;
}
