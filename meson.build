project('com.github.nmmanx.sensory', 'vala', 'c')

cc = meson.get_compiler('c')
valac = meson.get_compiler('vala')

vapi_dir = join_paths(meson.current_source_dir(), 'vapi')

add_project_arguments(['--vapidir', vapi_dir], language: 'vala')

libsensors = cc.find_library('libsensors', has_headers: ['sensors/sensors.h', 'sensors/error.h'], required: true)
libsensors_vapi = valac.find_library('libsensors', dirs: vapi_dir, required: true)

executable(
    meson.project_name(),
    'src' / 'Application.vala',
    'src' / 'MainWindow.vala',
    'src' / 'SensorTreeView.vala',
    'src' / 'SensorTreeStore.vala',
    'src' / 'GraphPanel.vala',
    'src' / 'SensorModel.vala',
    'src' / 'model/SensorChip.vala',
    'src' / 'model/ChipFeature.vala',
    'src' / 'model/ChipSubFeature.vala',
    'src' / 'graph/GraphProfile.vala',
    'src' / 'graph/GraphWidget.vala',
    'src' / 'graph/TimeSeriesData.vala',
    'src' / 'Debug.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('gee-0.8'),
        libsensors,
        libsensors_vapi
    ],
)