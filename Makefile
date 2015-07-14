# Makefile for generating a Liquidfun library using Emscripten.
#
# build with       emmake make
#
# ===============

PYTHON=$(ENV) python
ACTIVE=liquidfun/liquidfun/Box2D
VERSION=v1.1.0

# = min ==============
BUILD=min
OPTS = -Os
LINK_OPTS =  -O3 --llvm-lto 1 -s NO_FILESYSTEM=1 -s NO_BROWSER=1 -s ASSERTIONS=2 --closure 1  --js-transform "python tools/bundle.py"

# = debug ==============
# BUILD=debug
# EMCC_DEBUG=1
# OPTS = -Os
# LINK_OPTS = -g4 -s DEMANGLE_SUPPORT=1 -Werror -s ASSERTIONS=2 --llvm-lto 1 -s NO_FILESYSTEM=1 -s NO_BROWSER=1 -s ASSERTIONS=2 --closure 1  --js-transform "python tools/bundle.py"

OBJECTS += \
$(ACTIVE)/Box2D/Collision/b2BroadPhase.bc \
$(ACTIVE)/Box2D/Collision/b2CollideCircle.bc \
$(ACTIVE)/Box2D/Collision/b2CollideEdge.bc \
$(ACTIVE)/Box2D/Collision/b2CollidePolygon.bc \
$(ACTIVE)/Box2D/Collision/b2Collision.bc \
$(ACTIVE)/Box2D/Collision/b2Distance.bc \
$(ACTIVE)/Box2D/Collision/b2DynamicTree.bc \
$(ACTIVE)/Box2D/Collision/b2TimeOfImpact.bc \
$(ACTIVE)/Box2D/Collision/Shapes/b2ChainShape.bc \
$(ACTIVE)/Box2D/Collision/Shapes/b2CircleShape.bc \
$(ACTIVE)/Box2D/Collision/Shapes/b2EdgeShape.bc \
$(ACTIVE)/Box2D/Collision/Shapes/b2PolygonShape.bc \
$(ACTIVE)/Box2D/Common/b2BlockAllocator.bc \
$(ACTIVE)/Box2D/Common/b2Draw.bc \
$(ACTIVE)/Box2D/Common/b2Math.bc \
$(ACTIVE)/Box2D/Common/b2Settings.bc \
$(ACTIVE)/Box2D/Common/b2StackAllocator.bc \
$(ACTIVE)/Box2D/Common/b2Timer.bc \
$(ACTIVE)/Box2D/Common/b2TrackedBlock.bc \
$(ACTIVE)/Box2D/Dynamics/b2Body.bc \
$(ACTIVE)/Box2D/Dynamics/b2ContactManager.bc \
$(ACTIVE)/Box2D/Dynamics/b2Fixture.bc \
$(ACTIVE)/Box2D/Dynamics/b2Island.bc \
$(ACTIVE)/Box2D/Dynamics/b2World.bc \
$(ACTIVE)/Box2D/Dynamics/b2WorldCallbacks.bc \
$(ACTIVE)/Box2D/Dynamics/Contacts/b2ChainAndCircleContact.bc \
$(ACTIVE)/Box2D/Dynamics/Contacts/b2ChainAndPolygonContact.bc \
$(ACTIVE)/Box2D/Dynamics/Contacts/b2CircleContact.bc \
$(ACTIVE)/Box2D/Dynamics/Contacts/b2Contact.bc \
$(ACTIVE)/Box2D/Dynamics/Contacts/b2ContactSolver.bc \
$(ACTIVE)/Box2D/Dynamics/Contacts/b2EdgeAndCircleContact.bc \
$(ACTIVE)/Box2D/Dynamics/Contacts/b2EdgeAndPolygonContact.bc \
$(ACTIVE)/Box2D/Dynamics/Contacts/b2PolygonAndCircleContact.bc \
$(ACTIVE)/Box2D/Dynamics/Contacts/b2PolygonContact.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2DistanceJoint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2FrictionJoint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2GearJoint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2Joint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2MotorJoint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2MouseJoint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2PrismaticJoint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2PulleyJoint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2RevoluteJoint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2RopeJoint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2WeldJoint.bc \
$(ACTIVE)/Box2D/Dynamics/Joints/b2WheelJoint.bc \
$(ACTIVE)/Box2D/Particle/b2Particle.bc \
$(ACTIVE)/Box2D/Particle/b2ParticleAssembly.bc \
$(ACTIVE)/Box2D/Particle/b2ParticleGroup.bc \
$(ACTIVE)/Box2D/Particle/b2ParticleSystem.bc \
$(ACTIVE)/Box2D/Particle/b2VoronoiDiagram.bc \
$(ACTIVE)/Box2D/Rope/b2Rope.bc


all: remove liquidfun.js
	@echo "liquidfun_"$(VERSION)"."$(BUILD)".js is ready"

%.bc: %.cpp
	$(CXX) $(OPTS) -I$(ACTIVE) $< -o $@

liquidfun.bc: $(OBJECTS)
	$(CXX) $(OPTS) -I$(ACTIVE) -o $@ $(OBJECTS)

liquidfun_glue.cpp: liquidfun.idl
	$(PYTHON) $(EMSCRIPTEN)/tools/webidl_binder.py liquidfun.idl liquidfun_glue

liquidfun_glue.h: liquidfun_glue.cpp

liquidfun.js: liquidfun.bc liquidfun_glue.cpp liquidfun_glue.h
	$(CXX) $(LINK_OPTS) -I$(ACTIVE) -s EXPORT_BINDINGS=1 -s RESERVED_FUNCTION_POINTERS=20 --post-js liquidfun_glue.js --memory-init-file 0 -s NO_EXIT_RUNTIME=1 glue_stub.cpp $< -o build/liquidfun_$(VERSION).$(BUILD).js

clean: remove
	rm -f $(OBJECTS)
	
remove:
	rm -f liquidfun.bc liquidfun_bindings.cpp liquidfun_bindings.bc liquidfun.clean.h liquidfun_glue.js liquidfun_glue.cpp WebIDLGrammar.pkl parser.out

