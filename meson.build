project('com.github.nmmanx.temon', 'vala', 'c')

cc = meson.get_compiler('c')
valac = meson.get_compiler('vala')

vapi_dir = join_paths(meson.current_source_dir(), 'vapi')

add_project_arguments(['--vapidir', vapi_dir], language: 'vala')

libsensors = cc.find_library('libsensors', has_headers: ['sensors/sensors.h', 'sensors/error.h'], required: true)
libsensors_vapi = valac.find_library('libsensors', dirs: vapi_dir, required: true)

executable(
    meson.project_name(),
    'src' / 'Application.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        libsensors,
        libsensors_vapi
    ],
)